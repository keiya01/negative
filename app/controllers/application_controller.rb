class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_current_user

  def check_current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def brock_not_current_user
  	unless @current_user
  		flash[:notice] = "ログインしてください。"
  		redirect_to("/")
  	end
  end

  def brock_current_user
  	if @current_user
  		flash[:notice] = "すでにログインしています。"
  		redirect_to("/users/#{@current_user.nickname}")
  	end
  end

end
