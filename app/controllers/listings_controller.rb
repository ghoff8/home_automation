class ListingsController < ApplicationController

    def authenticated?
        session[:access_token]
    end
    
    def listing_params
        params.require(:listing).permit(:name, :time_created)
    end
    
    def show
        if !authenticated?
          redirect '/'
          return
        end
        @listing = Listing.find(params[:id])
        @devices = @listing.devices
        @reservations = @listing.reservations
    end
    
    def index
        @listings = Listing.all
    end
    
    def new

    end
    
    def edit
        @listing = Listing.find(params[:id])
    end
    
    def create
        params[:time_created] = Time.now
        begin
            @listing = Listing.create!(listing_params)
        rescue ActiveRecord::RecordInvalid
            flash[:deny] = "Name is required for new listing."
            redirect_to listings_path
            return
        end
        
        flash[:success] = "Listing #{@listing.name} was created successfully!"
        redirect_to listings_path
    end
    
    def destroy
        @listing = Listing.find(params[:id])
        @devices = Device.where(listing_id: @listing.id)
        @devices.each do |device|
            device.destroy
        end
        @listing.destroy
        
        flash[:notice] = "Listing '#{@listing.name}' deleted"
        redirect_to listings_path
    end
    
end