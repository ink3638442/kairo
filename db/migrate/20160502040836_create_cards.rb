class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :kind
      t.string :title
      t.text :content
      t.string :image
      t.boolean :pick_up, default: false
      t.references :user, index: true
      t.references :page, index: true

      t.timestamps null: false
    end
  end
end
