class ThreadContent < ActiveRecord::Base
  belongs_to :group_thread
  belongs_to :user
end
