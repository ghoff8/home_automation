class Listing < ActiveRecord::Base
    has_many :devices
    has_many :reservations
    validates_presence_of :name
    after_initialize :init
    
    def init
        self.time_created ||= Time.zone.now#.in_time_zone("Eastern Time (US & Canada)")
    end
end