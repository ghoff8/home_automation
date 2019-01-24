class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string 'listing_id'
      t.string 'name'
      t.datetime 'start_date'
      t.datetime 'end_date'
    end
  end
end