class EventRequestMailer < ApplicationMailer

  def sad_news(event)
    @parent = event.parent

    mail(to: @parent.email, subject: '[SitterBot] Sad news')
  end

  def accepted(event)
    @parent = event.parent
    @event = event
    @event_request = @event.event_requests.approved.first

    mail(to: @parent.email, subject: '[SitterBot] Booked!')
  end

  def send_request(event, event_request)
    @event = event
    @event_request = event_request
    @sitter = event_request.sitter
    @parent = event.parent

    mail(to: @sitter.email, subject: '[SitterBot] Available?')
  end
end
