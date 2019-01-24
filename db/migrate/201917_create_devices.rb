class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer 'device_id'
      t.integer 'listing_id'
      t.string 'name'
      t.string 'device_type'
    end
  end
end