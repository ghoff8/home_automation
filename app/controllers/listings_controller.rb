class ListingsController < ApplicationController
    # Our client ID and secret, used to get the access token
    
    def listing_params
        params.require(:listing).permit(:name, :time_created)
    end
    
    def show
        id = params[:id]
        @listing = Listing.find(id)
        @devices = @listing.devices
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
        #params.require(:name)
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
        @listing.destroy
        flash[:notice] = "Listing '#{@listing.name}' deleted"
        redirect_to listings_path
    end
    
end