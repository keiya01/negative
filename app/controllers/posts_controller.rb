class PostsController < ApplicationController
	before_action :post_params, {only:[:create]}
  before_action :brock_not_current_user, {only:[:show, :new, :create, :destroy]}
  before_action :find_post, {only:[:show, :destroy, :check_answer, :brock_not_post_user]}
  before_action :find_answerer, {only:[:show, :check_answer]}
  before_action :brock_not_post_user, {only:[:destroy]}

  # def index
  # 	@posts = Post.page(params[:page]).per(15).order(created_at: "DESC")
  #   @comment = Comment.new
  #  redirect_to '/'
  # end

  def show
  	@user = User.find(@post.user_id)
    @comments = Comment.where(post_id: @post.id).order(created_at: 'DESC')
    @comment = Comment.new
    @answerers = AnswerHistory.where(post_id: @post.id).order(number: 'ASC')
    if @answerer || @current_user.id == @post.user_id
      return
    else
      # ログインユーザーがAnswerHistoryに載っていないか、投稿主idとログインユーザが一致しなければリダイレクト。
      flash[:notice] = "問題に答えてください。"
      redirect_to '/'
    end
  end

  def new
    @random = SecureRandom.hex(10)
  	@post = Post.new
    @question_samples = [
      {'name' => '誕生日', 'text' => 'わたしの誕生日は？'},
      {'name' => '好きな人', 'text' => 'わたしの好きな人は？'},
      {'name' => '趣味', 'text' => 'わたしの趣味は？'},
      {'name' => '武勇伝', 'text' => 'わたしの武勇伝は？'},
      {'name' => '歌手', 'text' => 'わたしの好きな歌手は？'},
      {'name' => 'スポーツ', 'text' => 'わたしの尊敬するスポーツ選手は？'},
      {'name' => '座右の銘', 'text' => 'わたしの座右の銘は？'},
      {'name' => '好み', 'text' => 'わたしの好みのタイプは？'},
      {'name' => '食べ物', 'text' => 'わたしの好きな食べ物は？'}
    ]
  end

  def create
  	@post = Post.new(post_params)
  	if @post.save
      @user = User.find(@post.user_id)
      session[:new_post] = @post.id
  		flash[:notice] = '投稿しました。'
  		redirect_to "/users/#{@user.nickname}"
  	else
  		render 'posts/new'
  	end
  end

  def destroy
    user = User.find(@post.user_id)
    if @post
      @post.destroy
      redirect_to "/users/#{user.nickname}", notice: "削除しました。"
    else
      redirect_to '/users/#{user.nickname}', notice: "エラーが発生しました。"
    end
  end

  def check_answer
    user_answer = params[:answer]
    user = User.find(@post.user_id)
    @answer_history = AnswerHistory.find_by(user_id: @current_user.id, post_id: @post.id) if @current_user
    if @post.check_count < @post.count
      if @post.answer == user_answer || @current_user && session[:correct_user] == @post.id
        # 答えがあっているか、ログインユーザーのセッションidを持っていればパス
        if @current_user && @current_user.id != user.id
          # ログインユーザーがAnswerHistoryに載っていないかつログインユーザーならパス。
          @post.check_count += 1
          @post.save
          if @answer_history
            # すでにユーザーが回答していて、不正解のため履歴に残っていた場合trueを代入して正解判定にする。
            @answer_history.check = true
            @answer_history.number = @post.check_count
            @answer_history.save
          else
            @history = AnswerHistory.new(user_id: @current_user.id, post_id: @post.id, number: @post.check_count, check: true)
            @history.save
          end
          # 正常に処理が終わったらここで終了
          redirect_to "/posts/#{@post.random_key}", notice: '正解です！！'
          return
        elsif !@current_user
          # 正解したらサインアップフォームへ行き、登録後に正解ページへリダイレクトする。
          session[:correct_user] = @post.id
          redirect_to '/', notice: '正解です！ログインしてください！'
          return
        else
          flash[:notice] = '解答済みです。'
        end
      else
        if @current_user && !@answer_history || @current_user && session[:wrong_user] == @post.id
          @history = AnswerHistory.new(user_id: @current_user.id, post_id: @post.id, number: @post.check_count, check: false)
          @history.save
          flash[:notice] = '不正解です！！'
        elsif @current_user && @answer_history
          flash[:notice] = '不正解です！よく考えて！'
        else
          # 不正解ならサインアップフォームへ行き、登録後にAnswerHistoryに書き込む。
          session[:wrong_user] = @post.id
          redirect_to '/', notice: '不正解です！ログインしてください！'
          return
        end
      end
    else
      flash[:notice] = '定員に達しました。'
    end
    # 不正解のときマイページへ遷移
      redirect_to "/users/#{user.nickname}"
  end

  def brock_not_post_user
    user = User.find(@post.user_id)
    if user.id != @current_user.id
      redirect_to "/users/#{user.nickname}", notice: "権限がありません。"
    end
  end

  private
   def post_params
   	 params.require('post').permit(:body, :user_id, :question, :answer, :count, :check_count, :random_key)
   end

   def find_post
     @post = Post.find_by(random_key: params[:random_key])
   end

   def find_answerer
     @answerer = AnswerHistory.find_by(user_id: @current_user.id, post_id: @post.id) if @current_user
   end

end
