class AddContentToGroupThreads < ActiveRecord::Migration
  def change
    add_column :group_threads, :content, :text
  end
end
