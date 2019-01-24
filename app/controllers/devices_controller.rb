class DevicesController < ApplicationController
    
    def device_params
        params.require(:device).permit(:name, :device_type, :listing_id)
    end
    
    def new
        @listing = Listing.find(params[:listing_id])
        
    end
    
    def create
        @listing = Listing.find(params[:listing_id])
        
        begin
            @device = Device.create!(device_params.merge(:listing_id => @listing.id))
            @device.listing_id = @listing.id
        rescue ActiveRecord::RecordInvalid
            flash[:deny] = "Name and type is required for device."
            redirect_to listing_path(@listing.id)
            return
        end
        
        flash[:success] = "Device #{@device.name} created successfully!"
        redirect_to listing_path(@listing.id)
    end
    
end