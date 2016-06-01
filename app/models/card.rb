class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :page
  
  validates :title,  presence: true, length: { maximum: 50 }
  validates :content,  length: { maximum: 150 }
  mount_uploader :image, ImageUploader
  default_scope -> { order(created_at: :desc) }
  
end
