class UsersController < ApplicationController

	def new
	end

	def create
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    if user
      session[:user_id] = user.id
      redirect_to root_path, notice: "ログインしました。"
    else
      redirect_to '/users/new', notice: "失敗しました。"
    end
  end

end
