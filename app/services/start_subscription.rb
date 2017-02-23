class StartSubscription
  attr_reader :subscription, :user, :errors

  def initialize(user, params)
    @params = params
    @user = user
    @subscription = build_subscription
    @errors = []
  end

  def call
    customer = create_stripe_customer
    if customer && customer.id
      @subscription.stripe_id = customer.id
      @subscription.save!
      user.subscription = @subscription
      user.save!
    else
      @errors << 'Invalid card'
    end
  end

  def valid?
    errors.empty?
  end

  def build_subscription
    Subscription.new(@params) do |s|
      s.parent = user
      s.current_price = s.plan.price
      s.paid_thru = 15.days.from_now
    end
  end

  def create_stripe_customer
    begin
      customer = Stripe::Customer.create(
        :source => subscription.credit_card_token,
        :plan => subscription.plan.stripe_id,
        :email => user.email
      )
      Rails.logger.info customer
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]
      @errors << body[:error]

      puts "Status is: #{e.http_status}"
      puts "Type is: #{err[:type]}"
      puts "Code is: #{err[:code]}"
      # param is '' in this case
      puts "Param is: #{err[:param]}"
      puts "Message is: #{err[:message]}"
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly

      Rails.logger.info e
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
      Rails.logger.info e
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
      Rails.logger.info e
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
      Rails.logger.info e
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
      Rails.logger.info e
    rescue => e
      # Something else happened, completely unrelated to Stripe
      Rails.logger.info e
    end
    customer
  end
end
