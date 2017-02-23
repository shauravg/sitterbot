class SessionsController < ApplicationController
  def new
    @user = User.new
    render layout: 'auth'
  end

  def create
    @user = User.find_by_params(user_params)
    if @user
      login(@user)
      redirect_to '/'
    else
      @user = User.new(user_params)
      flash.now[:errors] = [
        'Hmm. There is not a user with that email / password combo. Try again?']
      render :new, layout: 'auth'
    end
  end

  def destroy
    logout
    redirect_to '/welcome'
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end

