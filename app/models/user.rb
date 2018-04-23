class User < ApplicationRecord
  mount_uploader :image_url, ImageUploader
  validates :provider, presence: true
  validates :uid, presence: true
  validates :username, presence: true
  validates :email, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, allow_blank: true

  def self.find_or_create_from_auth_hash(auth_hash)
   provider = auth_hash[:provider]
   uid = auth_hash[:uid]
   name = auth_hash[:info][:name]

   self.find_or_create_by(provider: provider,uid: uid) do |user|
     user.username = name
   end
  end

end
