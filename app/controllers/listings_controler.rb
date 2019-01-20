class ListingsController < ApplicationController
    
    def listing_params
        params.require(:listing).permit(:id, :name, :devices, :time_created)
    end
    
    def show
        id = params[:id]
        @listing = Listing.find(id)
    end
    
    def index
        @listings = Listing.all
    end
    
    def new

    end
    
    def edit
        @listing = Listing.find params[:id]
    end
end