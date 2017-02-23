# == Schema Information
#
# Table name: events
#
#  id            :integer          not null, primary key
#  food_included :boolean          default(FALSE)
#  starts_at     :datetime         not null
#  ends_at       :datetime         not null
#  key           :string           not null
#  sitter_id     :integer
#  parent_id     :integer          not null
#  flat_rate     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  name          :string
#  reminded      :boolean          default(FALSE)
#  started       :boolean          default(FALSE)
#
# Indexes
#
#  index_events_on_parent_id  (parent_id)
#  index_events_on_sitter_id  (sitter_id)
#

class Event < ActiveRecord::Base
  validates :parent, presence: true
  belongs_to :sitter
  belongs_to :parent, class_name: 'User', foreign_key: :parent_id
  has_many :event_requests
  has_many :contacted_sitters, through: :event_requests, source: :sitter

  before_validation(on: :create) do
    self.key ||= SecureRandom.hex(2)
  end

  def accepted!
    EventRequestMailer.accepted(self).deliver_later
    TextParentJob.perform_later(
      parent.id,
      "Great news! #{ sitter.name } will watch #{ parent.kid_names } #{ in_words }")
  end

  def pretty_start
    starts_at.strftime("%l:%M %p")
  end

  def pretty_end
    ends_at.strftime("%l:%M %p")
  end

  def pretty_date
    starts_at.strftime("%a %b %d")
  end

  def in_words
    "from #{ pretty_start } to #{ pretty_end } on #{ pretty_date }"
  end

  def accepted?
    event_requests.approved.exists? && sitter
  end

  def duration
    # in hours
    (ends_at - starts_at) / 60 / 60
  end

  def next_sitter
    parent
      .sitters
      .where.not(id: contacted_sitter_ids)
      .order(:ord)
      .first
  end

  def last_request
    event_requests.order(created_at: :desc)
  end
end
