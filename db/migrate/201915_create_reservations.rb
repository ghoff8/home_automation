class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string 'listing_id'
      t.string 'name'
      t.datetime 'start_time'
      t.datetime 'end_time'
    end
  end
end