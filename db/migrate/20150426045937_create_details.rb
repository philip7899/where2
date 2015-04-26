class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.integer :high_price
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
