module ApplicationHelper

	def simple_time(time)
		# 条件分岐で時間の表記の仕方を変える
		# 例：　「1時間前」、「10分前」、「5分前」、「数分前」
		time.strftime("%Y-%m-%d　%H:%M")
	end

	def get_twitter_card_info(page)
      twitter_card = {}
      if page
        twitter_card[:url] = "https://www.locqer.com/users/#{page.id}"
        twitter_card[:title] = "問題を作ったよ！"
        twitter_card[:description] = "問題に答えて隠し事を暴こう！"
        twitter_card[:image] = "#{asset_url("IMG_8323.JPG")}"
      else
        twitter_card[:url] = 'https://www.locqer.com'
        twitter_card[:title] = '秘密を打ち明けるSNS「LOCQER」'
        twitter_card[:description] = 'あなたの友達の問題を解いて秘密を打ち明けてみよう！'
        twitter_card[:image] = "#{asset_url("IMG_8323.JPG")}"
      end
      twitter_card[:card] = 'summary'
      twitter_card[:site] = '@Yapy_service'
      twitter_card
  	end

end
