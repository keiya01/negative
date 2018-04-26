class CommentsController < ApplicationController

  def create
  	@post = Post.find(params[:id])
  	@comment = Comment.new(body: params[:body], post_id: @post.id, user_id: @current_user.id)
  	if @post.count < 3
      if @comment.save
        @post.count = 0 if @post.count == nil
        @post.count += 1
        @post.save
        flash[:notice] = 'コメントしました。'
        redirect_to '/'
      end
    else
        flash[:notice] = 'コメントできませんでした。'
        redirect_to '/'
    end
  end

end
