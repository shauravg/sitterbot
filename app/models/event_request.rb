# == Schema Information
#
# Table name: event_requests
#
#  id         :integer          not null, primary key
#  event_id   :integer          not null
#  sitter_id  :integer          not null
#  texted     :boolean          default(FALSE)
#  emailed    :boolean          default(FALSE)
#  state      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_event_requests_on_event_id   (event_id)
#  index_event_requests_on_sitter_id  (sitter_id)
#

class EventRequest < ActiveRecord::Base
  belongs_to :event
  belongs_to :sitter
  enum state: {
    unsent: 0,
    sending: 1,
    sent: 2,
    approved: 3,
    denied: 4,
    timedout: 5
  }
  scope :approved, -> { where(state: 3) }

  def value
    event.duration * sitter.hourly_rate
  end
end
