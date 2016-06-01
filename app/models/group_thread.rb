class GroupThread < ActiveRecord::Base
  belongs_to :group
  has_many :thread_contents
  has_many :users, through: :thread_contents
end
