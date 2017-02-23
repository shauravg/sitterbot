class FindSitterJob < ActiveJob::Base
  queue_as :default
  attr_reader :event

  def perform(event_id)
    @event = Event.find(event_id)
    @event.update(started: true)
    return if @event.accepted?
    # Send an email and text to the first sitter that has not yet been contacted
    if !sitter
      email_parent
    else
      email_sitter
      text_sitter
    end
    # Start a timer for 30 min
    # When the timer expires, call this job again
  end

  def parent
    event.parent
  end

  def event_request
    @event_request ||= EventRequest.create!(
      sitter: sitter,
      event: event,
    )
  end

  def sitter
    @sitter ||= event.next_sitter
  end

  def email_parent
    EventRequestMailer.sad_news(event).deliver_later
  end

  def email_sitter
    return if !sitter.email
    EventRequestMailer.send_request(event, event_request).deliver_later
    event_request.update(emailed: true)
    if event_request.state.to_i < 1
      event_request.update(state: 1)
    end
  end

  def client
    @client ||= Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
  end

  def alert_message
    <<-SMS
Hey #{ sitter.name } any chance you could watch #{ parent.kid_names }
#{ event.in_words } (est. $#{ event_request.value })?
-- #{ parent.name }

Reply Yes #{ event.key } or No #{ event.key }
    SMS
  end

  def text_sitter
    return if !sitter.phone
    client.messages.create(
      from: ENV['TWILIO_NUMBER'],
      to: sitter.phone,
      body: alert_message,
    )
    event_request.update(texted: true)
    if event_request.state.to_i < 1
      event_request.update(state: 2)
    end
  end
end
