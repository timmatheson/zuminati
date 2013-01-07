class AddBedroomsAndSqrftToListings < ActiveRecord::Migration
  def change
    add_column :listings, :bedrooms, :decimal
    add_column :listings, :sqrft, :integer
  end
end
