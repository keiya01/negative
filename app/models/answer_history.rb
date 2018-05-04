class AnswerHistory < ApplicationRecord
	validates :user_id, presence: true
	validates :post_id, presence: true
	validates :number, presence: true
end
