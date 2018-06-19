class CommentsController < ApplicationController

  def create
  	@post = Post.find_by(random_key: params[:random_key])
    @comments = Comment.where(post_id: @post.id).order(created_at: 'DESC')
  	@comment = Comment.new(params_comment)
    respond_to do |format|
      if @comment.save
        format.html{ redirect_to "/posts/#{@post.random_key}", notice: 'コメントしました。' }
        format.js
      else
        format.html{ redirect_to "/posts/#{@post.random_key}", notice: 'コメントに失敗しました。' }
      end
    end
  end

  private
  def params_comment
    params.require('comment').permit(:body, :post_id, :user_id)
  end

end
