class CreateGroupThreads < ActiveRecord::Migration
  def change
    create_table :group_threads do |t|
      t.string :title
      t.references :group, index: true

      t.timestamps null: false
    end
  end
end
