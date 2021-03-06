class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  attr_accessor :remember_token
  has_secure_password
  validate :add_presence_errors
  validates :email, uniqueness: {message: "は他の人が先に登録しているみたい...", allow_blank: true}, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "は正しくないよ！", allow_blank: true}, on: :update
  validates :nickname, uniqueness: {message: "は他の人が先に登録しているみたい..."}, format: { with: /\A[A-Za-z\w_-]+\z/i, message: "は正しくないよ！" }, length: {minimum: 3, message: "は3文字以上で入力してください"}
  has_many :posts, dependent: :destroy


  def self.find_or_create_from_auth_hash(auth_hash)
   provider = auth_hash[:provider]
   uid = auth_hash[:uid]
   nickname = auth_hash[:info][:nickname]
   username = auth_hash[:info][:name]
   image_url = auth_hash[:info][:image]

   self.find_or_create_by(provider: provider,uid: uid) do |user|
     user.nickname = nickname
     user.username = username
     user.icon_url = image_url
     user.password = "password"
   end
  end

  # cookieの保存
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def add_presence_errors
    if nickname.empty?
      errors.add(:nickname, "を教えてください！")
    elsif username.empty?
      errors.add(:username, "を教えてください！")
    end
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

end
