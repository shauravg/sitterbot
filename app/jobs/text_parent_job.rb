class TextParentJob < ActiveJob::Base
  queue_as :default
  attr_reader :parent, :message

  def perform(parent_id, message)
    @parent = User.find(parent_id)
    @message = message
    text_parent
  end

  def text_parent
    return if !parent.phone
    client.messages.create(
      from: ENV['TWILIO_NUMBER'],
      to: parent.phone,
      body: message,
    )
  end

  def client
    @client ||= Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
  end
end
