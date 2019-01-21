class Listing < ActiveRecord::Base
    has_many :devices
    validates_presence_of :name
    after_initialize :init
    
    def init
        self.time_created ||= DateTime.now.in_time_zone("Eastern Time (US & Canada)")
        self.devices ||= "None"
    end
end