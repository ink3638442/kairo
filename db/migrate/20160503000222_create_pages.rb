class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :card_order
      t.text :content
      t.date :group_joined_at
      t.references :user, index: true
      t.references :group, index: true

      t.timestamps null: false
    end
  end
end
