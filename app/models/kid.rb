# == Schema Information
#
# Table name: kids
#
#  id           :integer          not null, primary key
#  parent_id    :integer          not null
#  nickname     :string           not null
#  birthdate    :date
#  instructions :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_kids_on_parent_id  (parent_id)
#

class Kid < ActiveRecord::Base
  belongs_to :parent, class_name: 'User', foreign_key: :parent_id
  validates :nickname, :parent, presence: true
  validates :nickname, uniqueness: { scope: :parent }

  def age
    now = Time.now.utc.to_date
    now.year - birthdate.year - (birthdate.to_date.change(:year => now.year) > now ? 1 : 0)
  end
end
