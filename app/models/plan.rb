# == Schema Information
#
# Table name: plans
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  stripe_id     :string           not null
#  price         :integer
#  interval      :string
#  features      :text
#  highlight     :boolean
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Plan < ActiveRecord::Base
  validates :name, :stripe_id, presence: true
end
