# == Schema Information
#
# Table name: subscriptions
#
#  id                :integer          not null, primary key
#  stripe_id         :string
#  plan_id           :integer          not null
#  last_four         :string
#  coupon_id         :integer
#  card_type         :string
#  current_price     :integer
#  parent_id         :integer
#  paid_thru         :datetime
#  credit_card_token :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_plan_id  (plan_id)
#

class Subscription < ActiveRecord::Base
  belongs_to :plan
  belongs_to :parent, class_name: 'User', foreign_key: :parent_id
end
