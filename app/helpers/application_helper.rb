module ApplicationHelper

	def simple_time(time)
		# 条件分岐で時間の表記の仕方を変える
		# 例：　「1時間前」、「10分前」、「5分前」、「数分前」
		time.strftime("%Y-%m-%d　%H:%M")
	end

	def get_twitter_card_info(page)
      twitter_card = {}
      if page
        twitter_card[:url] = "https://www.locqer.com/users/#{page.nickname}"
        twitter_card[:title] = "問題を作ったよ！"
        twitter_card[:description] = "#{page.username}の問題に答えて思いを聞いてみよう！"
        twitter_card[:image] = "#{asset_url("IMG_8323.JPG")}"
      else
        twitter_card[:url] = 'https://www.locqer.com'
        twitter_card[:title] = '秘密を打ち明けるSNS「LOCQER」'
        twitter_card[:description] = 'あなたの思いを大切な人にだけ伝えてみよう！'
        twitter_card[:image] = "#{asset_url("IMG_8323.JPG")}"
      end
      twitter_card[:card] = 'summary_large_image'
      twitter_card[:site] = '@Yapy_service'
      twitter_card
  	end

  def guest_name_change(count)
    if count == 1
      "名前がわからない人"
    elsif count == 2
      "再び名前がわからない人"
    elsif count == 3
      "またまた名前がわからない人"
    else
      "ゲストの人"
    end
  end

end
