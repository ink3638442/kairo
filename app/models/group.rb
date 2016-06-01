class Group < ActiveRecord::Base
  has_many :pages
  has_many :users, through: :pages
  has_many :group_threads
end
