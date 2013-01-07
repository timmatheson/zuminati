class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :title
      t.string :description
      t.integer :category_id
      t.decimal :price
      t.boolean :spam
      t.string :source
      t.string :url
      t.boolean :featured
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :phone
      t.string :email
      t.string :image_url

      t.timestamps
    end
  end
end
