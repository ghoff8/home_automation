class Device < ActiveRecord::Base
    belongs_to :listing
    validates_presence_of :listing_id
    validates_presence_of :name
    validates_presence_of :device_type
    
end