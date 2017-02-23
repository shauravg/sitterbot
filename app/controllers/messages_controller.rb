class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    reply = ReplyHandler.new(params)
    @event_request = reply.event_request
    if reply.yes?
      if @event_request
        @event_request.update(state: 3)
        event = reply.event
        event.sitter = reply.sitter
        event.save!
        event.accepted!
      end
    else
      if @event_request
        @event_request.update(state: 4)
      end
      FindSitterJob.perform_later(@event_request.event)
    end
    render json: {}
  end
end
