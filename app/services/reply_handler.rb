class ReplyHandler
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def from_number
    params["From"][-10..-1]
  end

  def sitter
    Sitter.find_by(phone: from_number)
  end

  def event_request
    return if !sitter
    event.event_requests.find_by(sitter: sitter)
  end

  def event
    return if !sitter
    sitter.requested_events.find_by(key: event_key)
  end

  def yes?
    params["Body"].downcase.include?('yes')
  end

  def event_key
    parts = params["Body"].split(' ')
    if parts.length > 1
      parts[1].downcase
    end
  end
end
