class Listing < ActiveRecord::Base
    has_many :devices
    validates_presence_of :name
    after_initialize :init
    
    def init
        self.time_created ||= Time.zone.now#.in_time_zone("Eastern Time (US & Canada)")
    end
end