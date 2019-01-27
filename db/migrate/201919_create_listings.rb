class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string 'name'
      t.integer 'automation'
      t.datetime 'time_created'
    end
  end
end