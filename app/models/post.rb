class Post < ApplicationRecord
	validates :body, length:{maximum: 500}
	validates :question, length:{maximum: 150}
	validates :answer, length:{maximum: 30}
	validates :check_count, :user_id, presence: true
	validate :add_presence_errors
	has_many :answer_histories, dependent: :destroy
	belongs_to :user

	def add_presence_errors
		if body.empty?
			errors.add(:body, "を暴露しちゃおう！")
		elsif question.empty?
			errors.add(:question, "を出して友達を厳選しよう！")
		elsif answer.empty?
			errors.add(:answer, "がわからないよ...")
		elsif count.blank?
			errors.add(:count, "が選択されていないよ...")
		end
	end

end
