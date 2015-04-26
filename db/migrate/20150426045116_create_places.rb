class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :picture
      t.string :name

      t.timestamps
    end
  end
end
