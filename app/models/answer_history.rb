class AnswerHistory < ApplicationRecord
	validates :post_id, presence: true
	validates :number, presence: true
	belongs_to :post
end
