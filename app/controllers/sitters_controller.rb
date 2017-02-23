class SittersController < ApplicationController
  def new
    @sitter = Sitter.new
  end

  def edit
    @sitter = current_user.sitters.find(params[:id])
  end

  def index
    @sitters = current_user.sitters.order(:ord)
  end

  def create
    @sitter = current_user.sitters.new(sitter_params)

    if @sitter.save
      if params[:create_and_add]
        redirect_to new_sitter_path
      else
        redirect_to sitters_path
      end
    else
      flash.now[:errors] = @sitter.errors.full_messages
      render :new
    end
  end

  def show
    @sitter = current_user.sitters.find(params[:id])
  end

  def destroy
    @sitter = current_user.sitters.find(params[:id])
    @sitter.try(:destroy)
    redirect_to :back
  end

  def update
    @sitter = current_user.sitters.find(params[:id])

    if @sitter.update(sitter_params)
      redirect_to sitters_path
    else
      flash.now[:errors] = @sitter.errors.full_messages
      render :edit
    end
  end

  def share
    @sitter = current_user.sitters.find(params[:id])
    @receiving_user = User.find_by(email: params[:share_email])
    ShareMailer.share_email(current_user, @sitter, @receiving_user).deliver_now
    redirect_to :back
  end



  private

  def sitter_params
    params
      .require(:sitter)
      .permit(
        :paid,
        :hourly_rate,
        :phone,
        :email,
        :name,
        :can_drive,
        :ord,
        :per_extra_kid
      )
  end
end
