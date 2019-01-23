class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string 'listing_id'
      t.string 'name'
      t.string 'type'
    end
  end
end