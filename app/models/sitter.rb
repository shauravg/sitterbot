# == Schema Information
#
# Table name: sitters
#
#  id            :integer          not null, primary key
#  parent_id     :integer          not null
#  paid          :boolean          default(TRUE)
#  hourly_rate   :integer          default(10)
#  phone         :string
#  email         :string
#  name          :string           not null
#  can_drive     :boolean          default(TRUE)
#  per_extra_kid :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ord           :integer          default(0)
#
# Indexes
#
#  index_sitters_on_parent_id  (parent_id)
#

class Sitter < ActiveRecord::Base
  belongs_to :parent, class_name: 'User', foreign_key: :parent_id
  validates :name, :parent, presence: true
  validates :name, uniqueness: { scope: :parent }
  validates :phone, uniqueness: { scope: :parent }
  has_many :event_requests
  has_many :requested_events, through: :event_requests, source: :event

  def phone=(other)
    self[:phone] = other.gsub(/[^0-9]/, '')
  end
end
