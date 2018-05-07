class UsersController < ApplicationController
  before_action :brock_current_user, {only:[:new, :create]}
  before_action :brock_not_current_user, {only:[:edit, :update, :logout]}
  before_action :find_user, {only:[:show, :edit, :update, :brock_user]}
  before_action :brock_user, {only:[:edit, :update]}

  def show
    posts = Post.where(user_id: @user.id).order(created_at: 'DESC')
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(15)
  end

	def new
	end

	def create
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    if user.email.blank?
      session[:user_id] = user.id
      session[:new_user] = user.id
      redirect_to "/users/#{user.nickname}/edit", notice: "Emailを登録してください"
    elsif !user.email.blank?
      session[:user_id] = user.id
      flash[:notice] = "ログインしました！"
      if session[:post_id]
        @post = Post.find(session[:post_id])
        redirect_to "/posts/#{@post.random_key}/check"
      else
        redirect_to "/users/#{user.nickname}"
      end
    else
      redirect_to "/users/#{user.nickname}", notice: "エラーが発生しました。"
    end
  end

  def edit
  end

  def update
    if @user
      @user.username = params[:user][:username]
      @user.email = params[:user][:email]
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
  def find_user
    @user = User.find_by(nickname: params[:nickname])
  end

end
