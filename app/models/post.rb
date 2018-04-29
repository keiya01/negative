class Post < ApplicationRecord
	validates :body, presence: true, length:{maximum: 500}
	validates :question, presence: true, length:{maximum: 150}
	validates :answer, presence: true, length:{maximum: 30}
	validates :count, presence: true
	validates :check_count, presence: true
	validates :user_id, presence: true
end
