class Post < ApplicationRecord
	validates :body, presence: true, length:{maximum: 150}
end
