class UsersController < ApplicationController
  def new
    @user = User.new
    render layout: 'auth'
  end

  def edit
    @user = current_user
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      # Should we send them an email on signup or add them to a drip campaign?
      # UserMailer.new_user(@user).deliver_later
      redirect_to '/'
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new, layout: 'auth'
    end
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to '/user'
    else
      flash.now[:errors] = @user.errors.full_messages
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:time_zone, :email, :password, :selected_plan, :name, :phone)
  end
end

