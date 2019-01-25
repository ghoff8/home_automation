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
        rescue ActiveRecord::RecordInvalid
            flash[:deny] = "Name and type is required for device."
            redirect_to listing_path(@listing.id)
            return
        end
            
        flash[:success] = "Device #{@device.name} created successfully!"
        
        endpoints_uri = 'https://graph.api.smartthings.com/api/smartapps/endpoints'
        token = session[:access_token]
    
        # make a request to the SmartThings endpoint URI, using the token,
        # to get our endpoints
        url = URI.parse(endpoints_uri)
        req = Net::HTTP::Post.new(url.request_uri + "/addDevice")
        puts req.uri
        req.set_form_data('id' => @device.id, 'name' => @device.name, 'type' => @device.device_type)
        #we set a HTTP header of "Authorization: Bearer <API Token>"
        req['Authorization'] = 'Bearer ' + token
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = (url.scheme == "https")

        response = http.request(req)
        puts response
        redirect_to listing_path(@listing.id)
    end
    
end