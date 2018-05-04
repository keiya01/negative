class PostsController < ApplicationController
	before_action :post_params, {only:[:create]}
  before_action :brock_not_current_user, {only:[:new, :create]}
  before_action :find_post, {only:[:show, :destroy, :check_answer]}
  before_action :find_answerer, {only:[:show, :check_answer]}

  def index
  	@posts = Post.page(params[:page]).per(15).order(created_at: "DESC")
    @comment = Comment.new
  end

  def show
  	@user = User.find(@post.user_id)
    @answerers = AnswerHistory.where(post_id: @post.id).order(number: 'ASC')
    puts "test: #{@answerer}"
    if !@answerer
      flash[:notice] = "問題に答えてください。"
      redirect_to '/'
    end
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
    if @post
      @post.destroy
      redirect_to '/'
    else
      flash[:notice] = "エラーが発生しました。"
      redirect_to '/'
    end
  end

  def check_answer
    user_answer = params[:answer]
    if @post.check_count < @post.count
      if @post.answer == user_answer
        @post.check_count += 1
        @post.save
        flash[:notice] ='正解です！！'
        if @current_user && !@answerer
          @history = AnswerHistory.new(user_id: @current_user.id, post_id: @post.id, number: @post.check_count)
        else
          # ゲストは0で記入
          @history = AnswerHistory.new(user_id: 0, post_id: @post.id, number: @post.check_count)
        end
        if !@history.save
          redirect_to '/', notice: 'エラーが発生しました。'
        end
        session[:post_id] = @post.id
        redirect_to "/posts/#{@post.id}"
        return
      else
        flash[:notice] = '不正解です！！'
      end
    else
      flash[:notice] = '定員に達しました。'
    end
    if params[:uri] == "/users/#{@post.user_id}"
      redirect_to "/users/#{@post.user_id}"
    else
      redirect_to "/"
    end
  end

  private
   def post_params
   	 params.require('post').permit(:body, :user_id, :question, :answer, :count, :check_count)
   end

   def find_post
     @post = Post.find(params[:id])
   end

   def find_answerer
     @answerer = AnswerHistory.find_by(user_id: @current_user.id, post_id: @post.id)
   end

   

end
