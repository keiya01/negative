class CommentsController < ApplicationController

  def create
  	@post = Post.find_by(random_key: params[:random_key])
  	@comment = Comment.new(params_comment)
    if @comment.save
      redirect_to "/posts/#{@post.random_key}", notice: 'コメントしました。'
    else
        redirect_to "/posts/#{@post.random_key}", notice: 'コメントに失敗しました。'
    end
  end

  private
  def params_comment
    params.require('comment').permit(:body, :post_id, :user_id)
  end

end
