class SessionsController < ApplicationController
  def create
    user = User.omniauth(env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to "/page"
  end

  def destroy
    session[:user_id] = nil
  end
end
