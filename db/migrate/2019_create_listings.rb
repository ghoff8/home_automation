class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string 'name'
      t.string 'devices'
      
      t.timestamps
    end
  end
end