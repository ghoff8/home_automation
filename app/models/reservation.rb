class Reservation < ActiveRecord::Base
    belongs_to :listing
    validates_presence_of :name
    validates_presence_of :start_date
    validates_presence_of :end_date
    after_initialize :init
    
    def init
        self.time_created ||= Time.zone.now
    end
end