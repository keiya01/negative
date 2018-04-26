class Post < ApplicationRecord
	validates :body, presence: true, length:{maximum: 150}
	validates :user_id, presence: true
end
