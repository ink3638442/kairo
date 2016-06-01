class CreateThreadContents < ActiveRecord::Migration
  def change
    create_table :thread_contents do |t|
      t.references :group_thread, index: true
      t.references :user, index: true
      t.text :content

      t.timestamps null: false
    end
  end
end
