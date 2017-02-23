class SubscriptionsController < ApplicationController
  before_action :require_login!
  layout 'auth'

  def new
    if current_user.trial?
      redirect_to '/'
      return
    end

    if params[:plan]
      current_user.selected_plan = params[:plan]
      current_user.save
    end
  end

  def create
    service = StartSubscription.new(current_user, subscription_params)
    service.call
    if service.valid?
      login(service.user)
      redirect_to '/subscribed'
    else
      flash.now[:errors] = service.errors
      render :new
    end
  end

  def edit
  end

  def show
  end

  private

  def subscription_params
    params.require(:subscription).permit(
      :plan_id,
      :stripe_id,
      :credit_card_token,
      :card_type,
      :last_four
    )
  end
end
