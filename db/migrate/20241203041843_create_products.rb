class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :category
      t.text :description
      t.decimal :price
      t.integer :stock
      t.string :image_url

      t.timestamps
    end
  end
end
