class SessionsController < ApplicationController
  before_action :require_logged_out, only: [:new, :create]
  before_action :require_logged_in, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:email]
      params[:user][:password]
    )

    if @user
      login!(@user)
      redirect_to user_url(@user)
    else
      flash[:errors] = ["invalid credentials"]
      redirect_to new_session_url
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

end
