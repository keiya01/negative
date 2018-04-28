class CommentsController < ApplicationController

  def create
  	@post = Post.find(params[:id])
  	@comment = Comment.new(body: params[:body], post_id: @post.id, user_id: @current_user.id)
    if @comment.save
      flash[:notice] = 'コメントしました。'
      redirect_to '/'
    else
        flash[:notice] = 'コメントに失敗しました。'
        redirect_to '/'
    end
  end

end
