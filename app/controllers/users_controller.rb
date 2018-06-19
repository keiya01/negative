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
    p "TEST: [#{session[:correct_user]}]"
  end

	def new
    @users = User.all.limit(5).order(created_at: 'DESC')
    @user = User.new
	end

	def create
    if params[:auth] == 'self'
      @user = User.new(user_params)
    else
      @user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
      twitter_info = request.env['omniauth.auth']
      twitter_nickname = twitter_info['info']['nickname']
      twitter_username = twitter_info['info']['name']
      twitter_image = twitter_info['info']['image']
      @user.nickname = twitter_nickname if @user.nickname != twitter_nickname
      @user.username = twitter_username if @user.username != twitter_username
      @user.icon_url = twitter_image if @user.icon_url != twitter_image || @user.image.blank?
    end
    
    if @user.save
      session[:user_id] = @user.id
      remember @user
    else
      render 'users/new'
      return
    end
    if @user.email.blank?
      session[:new_user] = @user.id
      redirect_to "/users/#{@user.nickname}/edit", notice: "Emailを登録してください"
    elsif !@user.email.blank?
        redirect_to "/users/#{@user.nickname}", notice: "ログインしました！"
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
