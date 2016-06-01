class Page < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :cards
  serialize :card_order
  
  # validates :title,  presence: true, length: { maximum: 50 }
  # validates :content,  presence: true, length: { maximum: 150 }
  default_scope -> { order(created_at: :desc) }
  
end
