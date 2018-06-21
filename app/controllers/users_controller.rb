class UsersController < ApplicationController
  include UsersHelper
  before_action :brock_current_user, {only:[:new, :create]}
  before_action :brock_not_current_user, {only:[:edit, :update, :logout]}
  before_action :find_user, {only:[:show, :edit, :update, :brock_user]}
  before_action :brock_user, {only:[:edit, :update]}

  def show
    posts = Post.where(user_id: @user.id).order(created_at: 'DESC')
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(15)
    @new_post = Post.find(session[:new_post]) if session[:new_post]
  end

	def new
    @users = User.all.limit(5).order(created_at: 'DESC')
    @user = User.new
	end

	def create
    if params[:auth] == 'self'
      @user = User.new(user_params)
    else
      auth_user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
      twitter_info = request.env['omniauth.auth']
      twitter_nickname = twitter_info['info']['nickname']
      twitter_username = twitter_info['info']['name']
      twitter_image = twitter_info['info']['image']
      auth_user.update(nickname: twitter_nickname) if auth_user.nickname != twitter_nickname
      auth_user.update(username: twitter_username) if auth_user.username != twitter_username
      auth_user.update(icon_url: twitter_image) if auth_user.icon_url != twitter_image || auth_user.image.blank?
    end

    if auth_user || @user.save
      common_user = auth_user ? auth_user : @user
      session[:user_id] = common_user.id
      remember common_user
      redirect_to "/users/#{common_user.nickname}", notice: "ログインしました！"
    else
      render 'users/new'
    end

  end

  def edit
  end

  def update
    if @user
      @user.username = params[:user][:username]
      @user.email = params[:user][:email]
      if !params[:user][:image].blank?
        @user.image = params[:user][:image]
        @user.icon_url = nil
      end

      if @user.save && session[:post_id]
        post = Post.find(session[:post_id])
        redirect_to "/posts/#{post.random_key}/check", notice: "正解です！"
      elsif @user.save
        redirect_to "/users/#{@user.nickname}", notice: "更新しました！"
      else
        render 'users/edit'
      end
    end
  end

  def login
    @user = User.find_by(nickname: params[:nickname])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      remember @user
      redirect_to "/users/#{@user.nickname}", notice: "ログインしました！"
    else
      flash[:login_error] = "ユーザーIDまたはパスワードが違います。"
      redirect_back(fallback_location: root_path)
    end
  end

  def logout
    @user = User.find(session[:user_id])
    if @user
      forget @user if @user.remember_digest != nil
      session[:user_id] = nil
      redirect_to '/', notice: 'またきてね！'
    else
      redirect_to "/users/#{@user.nickname}", notice: '権限がありません。'
    end

  end

  def brock_user
    if @user.id != @current_user.id
      redirect_to "/users/#{@user.nickname}", notice: '権限がありません。'
    end
  end


  private
  def user_params
    params.require(:user).permit(:nickname, :username, :password, :icon_url, :image)
  end

  def find_user
    @user = User.find_by(nickname: params[:nickname])
  end

end
