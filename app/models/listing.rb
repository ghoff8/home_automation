class Listing < ActiveRecord::Base
    has_many :devices
    has_many :reservations
    validates_presence_of :name
    after_initialize :init
    
    def init
        self.time_created ||= Time.zone.now
        self.automation ||= 0
    end
end