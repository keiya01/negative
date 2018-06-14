class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_current_user
  before_action :check_user_post

  def check_current_user
  	if (user_id = session[:user_id])
      @current_user ||= User.find(user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find(user_id)
      if user && user.authenticated?(cookies[:remember_token])
        session[:user_id] = user.id
        @current_user = user
      end
    end
  end

  def check_user_post
    user = User.find_by(nickname: params[:nickname])
    @user_post ||= Post.find_by(user_id: user.id) if user
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

  def out_correct_user
    session[:correct_user] = nil if session[:correct_user]
  end

end
