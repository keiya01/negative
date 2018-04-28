class CommentsController < ApplicationController

  def create
  	@post = Post.find(params[:id])
  	@comment = Comment.new(body: params[:body], post_id: @post.id, user_id: @current_user.id)
  	if @post.count < @post.check_count
      if @comment.save
        @post.check_count = 0 if @post.check_count == nil
        @post.check_count += 1
        @post.save
        flash[:notice] = 'コメントしました。'
        session[:post_id] = @post.id
        redirect_to '/'
      end
    else
        flash[:notice] = '定員人数に達しています。'
        redirect_to '/'
    end
  end

end
