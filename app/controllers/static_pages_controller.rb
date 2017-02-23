class StaticPagesController < ApplicationController
  before_action :require_login!, only: [:root]
  before_action :require_subscription!, only: [:root]
  layout 'marketing'

  def root
    @events = current_user.events.order(starts_at: :desc)
    @sitters = current_user.sitters.order(:ord)
    render layout: 'application'
  end

  def subscribed
    render layout: false
  end

  def welcome
  end

  def letsencrypt
    render text: SslVerification.find_by(key: params[:id]).try(:value)
  end
end
