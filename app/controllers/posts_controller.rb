class PostsController < ApplicationController
	before_action :post_params, {only:[:create]}
  before_action :brock_not_current_user, {only:[:new, :create]}

  def index
  	@posts = Post.page(params[:page]).per(15).order(created_at: "DESC")
  end

  def new
  	@post = Post.new
  end

  def create
  	@post = Post.new(post_params)
  	if @post.save
  		flash[:notice] = '投稿しました。'
  		redirect_to '/'
  	else
  		render 'posts/new'
  	end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.count = 0 if @post.count == nil
    if @post.count == 2
      @post.destroy
      redirect_to '/'
    elsif @post.count < 3
      @post.count += 1
      @post.save
      redirect_to '/'
    else
      flash[:notice] = "エラーが発生しました。"
      redirect_to '/'
    end
  end

  private
   def post_params
   	 params.require('post').permit(:body)
   end
end
