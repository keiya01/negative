class Comment < ApplicationRecord
	validates :body, :user_id, :post_id, presence: true
	validates :body, length:{maximum: 150, message: 'が長過ぎるみたい！'}
end
