class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  
  has_many :cards
  has_many :pages
  has_many :groups, through: :pages
  has_many :thread_contents
  has_many :group_threads, through: :thread_contents
  
  
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  has_secure_password
  mount_uploader :image, ImageUploader
end
