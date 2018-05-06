class User < ApplicationRecord
  # mount_uploader :image, ImageUploader
  validates :provider, :uid, presence: true
  validate :add_presence_errors
  validates :email, uniqueness: {message: "は他の人が先に登録しているみたい..."}, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "は正しくないよ！" }, on: :update
  has_many :posts, dependent: :destroy
  has_many :answer_histories, dependent: :destroy

  def self.find_or_create_from_auth_hash(auth_hash)
   provider = auth_hash[:provider]
   uid = auth_hash[:uid]
   nickname = auth_hash[:info][:nickname]
   username = auth_hash[:info][:name]
   image_url = auth_hash[:info][:image]

   self.find_or_create_by(provider: provider,uid: uid) do |user|
     user.nickname = nickname
     user.username = username
     user.image = image_url
   end
  end

  def add_presence_errors
    if username.empty?
      errors.add(:username, "を知りたい！")
    end
  end

end
