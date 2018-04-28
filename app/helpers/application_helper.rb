module ApplicationHelper

	def simple_time(time)
		# 条件分岐で時間の表記の仕方を変える
		# 例：　「1時間前」、「10分前」、「5分前」、「数分前」
		time.strftime("%Y-%m-%d　%H:%M")
	end

end
