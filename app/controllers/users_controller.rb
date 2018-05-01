class UsersController < ApplicationController
  before_action :brock_current_user, {only:[:new, :create]}
  before_action :find_user, {only:[:show]}

  def show
    posts = Post.where(user_id: @user.id).order(created_at: 'DESC')
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(15)
  end

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

  private
  def find_user
    @user = User.find(params[:id])
  end

end
