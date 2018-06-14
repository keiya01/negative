class PostsController < ApplicationController
	before_action :post_params, {only:[:create]}
  before_action :brock_not_current_user, {only:[:new, :create, :destroy]}
  before_action :find_post, {only:[:show, :destroy, :check_answer, :brock_not_post_user]}
  before_action :find_answerer, {only:[:show, :check_answer]}
  before_action :brock_not_post_user, {only:[:destroy]}
  before_action :out_correct_user, {except: [:show]}

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
    if @answerer || @current_user && @current_user.id == @post.user_id || session[:correct_user] == @post.id
      return
    else
      # ログインユーザーがAnswerHistoryに載っていないか、投稿主idとログインユーザが一致しなければリダイレクト。
      flash[:notice] = "問題に答えてください。"
      redirect_to "/users/#{@user.nickname}"
    end
  end

  def new
    @random = SecureRandom.urlsafe_base64
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
      # 公開人数と問題に正解した人の数を比較
    if @post.check_count < @post.count
        # 答えがあっていればパス
      if @post.answer == user_answer
          # ログインユーザーかつログインユーザーと回答ユーザーのidが違うならパス。
        if !@current_user || @current_user.id != user.id
          @post.check_count += 1
          @post.save
          # 条件によってAnswerHistoryに保存する方法を変更する
          correct_answer_history_save(@answer_history, @post, @current_user)
          # 正常に処理が終わったらここで終了
          redirect_to "/posts/#{@post.random_key}", notice: '正解です！！'
          return
        else
          flash[:notice] = '無効な回答です。'
          redirect_to "/users/#{user.nickname}"
        end
      else
        flash[:notice] = '不正解です！！'
        if @current_user && !@answer_history
          @history = AnswerHistory.new(user_id: @current_user.id, post_id: @post.id, number: @post.check_count, check: false)
          @history.save
        elsif @current_user && @answer_history
          flash[:notice] = '不正解です！よく考えて！'
        elsif !@current_user
          @history = AnswerHistory.new(post_id: @post.id, number: @post.check_count, check: false)
          @history.save
        end
        # 不正解のとき回答したユーザー問題ページへ遷移
        redirect_to "/users/#{user.nickname}"
      end
    else
      redirect_to "/users/#{user.nickname}", notice: '定員に達しました。'
    end
  end

  def brock_not_post_user
    user = User.find(@post.user_id)
    redirect_to "/users/#{user.nickname}", notice: "権限がありません。" if user.id != @current_user.id
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

   def correct_answer_history_save(history, post, user)
    if user && history
      # すでにユーザーが回答していて、不正解のため履歴に残っていた場合trueを代入して正解判定にする。
      history.check = true
      history.number = post.check_count
      history.save
    elsif user && !history
      new_history = AnswerHistory.new(user_id: user.id, post_id: post.id, number: post.check_count, check: true)
      new_history.save
    elsif !user
      # ユーザーがログインしていない場合user_idに0を代入する
      new_history = AnswerHistory.new(user_id: 0, post_id: post.id, number: post.check_count, check: true)
      new_history.save
      session[:correct_user] = post.id
    end
  end

end
