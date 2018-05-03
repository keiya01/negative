class User < ApplicationRecord
  # mount_uploader :image, ImageUploader
  validates :provider, presence: true
  validates :uid, presence: true
  validates :username, presence: true
  has_many :posts, dependent: :destroy
  # validates :email, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, allow_blank: true

  def self.find_or_create_from_auth_hash(auth_hash)
   provider = auth_hash[:provider]
   uid = auth_hash[:uid]
   name = auth_hash[:info][:name]
   image_url = auth_hash[:info][:image]

   self.find_or_create_by(provider: provider,uid: uid) do |user|
     user.username = name
     user.image = image_url
   end
  end

end
