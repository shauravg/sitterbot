class EventReminderJob < ActiveJob::Base
  queue_as :default
  attr_reader :event

  def perform(event_id)
    @event = Event.find(event_id)
    if !@event.reminded
      send_email
      send_text
    end
  end

  def sitter
    @event.sitter
  end

  def send_email
    EventReminderMailer.remind(@event).deliver_later
  end

  def client
    @client ||= Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
  end

  def send_text
    client.messages.create(
      from: ENV['TWILIO_NUMBER'],
      to: sitter.phone,
      body: alert_message,
    )
  end
end
