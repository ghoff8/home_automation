class ReservationsController < ApplicationController
    
    def reservation_params
        params.require(:reservation).permit(:name, :start_date, :end_date)
    end
     
    def new
        @listing = Listing.find(params[:listing_id])
    end

    def create
        @timeCreated = Time.zone.now
        @listing = Listing.find(params[:listing_id])
        localParams = reservation_params
        begin
            if (@timeCreated.between?(localParams[:start_date], localParams[:end_date]) or (localParams[:start_date] > localParams[:end_date]))
                flash[:deny] = "Invalid reservation date ranges"
            else
                @reservation = Reservation.create!(localParams.merge(:listing_id => @listing.id))
                flash[:success] = "Reservation #{@reservation.name} was created successfully!"
            end
        rescue ActiveRecord::RecordInvalid, ArgumentError
            flash[:deny] = "Name, start date, and end date is required for new reservation."
        end
        
        redirect_to listing_path(:id => @listing.id)
    end
    
    def destroy
        @listing = Listing.find(params[:listing_id])
        @reservation = Reservation.find(params[:id])
        @reservation.destroy
        
        flash[:success] = "Reservation '#{@reservation.name}' deleted"
        redirect_to listing_path(@listing)
    end
    
    def show
        @listing = Listing.find(params[:listing_id])
        @reservation = Reservation.find(params[:id])
    end
end