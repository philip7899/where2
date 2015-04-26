class AddLocationCodeToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :location_code, :string
  end
end
