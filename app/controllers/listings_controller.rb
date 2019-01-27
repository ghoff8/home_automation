require 'json'
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
        @reservations = Reservation.where(listing_id: @listing.id)
        
        listToSend = {}
        
        @devices.each_with_index do |device, i|
            temp = "#{device.device_type}.#{device.id}"
            listToSend[i] = temp
        end
        @reservations.each do |res|
            res.destroy
        end
        puts listToSend.to_json
        endpoints_uri = 'https://graph.api.smartthings.com/api/smartapps/endpoints'
        token = session[:access_token]
    
        url = URI.parse(endpoints_uri)
        req = Net::HTTP::Get.new(url.request_uri)

        # we set a HTTP header of "Authorization: Bearer <API Token>"
        req['Authorization'] = 'Bearer ' + token
    
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = (url.scheme == "https")

        response = http.request(req)
        json = JSON.parse(response.body)
        uri = json[0]['uri']
        
        newUrl = uri + "/deleteDevices"
       
        deleteUrl = URI.parse(newUrl)
        
        deleteHttp = Net::HTTP.new(deleteUrl.host, deleteUrl.port)
        deleteHttp.use_ssl = true
       
        
        deleteReq = Net::HTTP::Post.new(deleteUrl.request_uri, 'Content-Type' => 'application/json')
        deleteReq['Authorization'] = 'Bearer ' + token
        deleteReq.body = listToSend.to_json
        #deleteReq.set_form_data('id' => @device.id, 'type' => @device.device_type)
        #we set a HTTP header of "Authorization: Bearer <API Token>
        
        response = deleteHttp.request(deleteReq)
        case response.body
        when "Devices Deleted"
            @devices.each do |device|
                device.destroy
            end
            @listing.destroy
            flash[:success] = "Listing '#{@listing.name}' deleted"
        else
            flash[:deny] = "Error deleting devices in Listing #{@listing}"
        end
        redirect_to listings_path
    end
    
    def automation
        @listing = Listing.find(params[:id])
        @reservations = @listing.reservations
        @devices = @listing.devices
        currentTime = Time.zone.now
        if (@listing.automation == 1)
            @listing.automation = 0
            @listing.save
            
        else
            @listing.automation = 1
            @listing.save
            
            lightsOff = true
            @reservations.each do |res|
                if (currentTime.between?(res.start_date, res.end_date))
                    lightsOff = false
                end
            end
            if (lightsOff)
                listToSend= {}
                @devices.each_with_index do |dev, i|
                    if(dev.device_type == "Light")
                        listToSend[i] = "#{dev.id}"
                    end
                end
                unless (listToSend.length == 0)
                    endpoints_uri = 'https://graph.api.smartthings.com/api/smartapps/endpoints'
                    token = session[:access_token]
                
                    url = URI.parse(endpoints_uri)
                    req = Net::HTTP::Get.new(url.request_uri)
                    
                    # we set a HTTP header of "Authorization: Bearer <API Token>"
                    req['Authorization'] = 'Bearer ' + token
                
                    http = Net::HTTP.new(url.host, url.port)
                    http.use_ssl = (url.scheme == "https")
                
                    response = http.request(req)
                    json = JSON.parse(response.body)
                    uri = json[0]['uri']
                        
                    newUrl = uri + "/turnOffLights"
                       
                    lightUrl = URI.parse(newUrl)
                        
                    lightHttp = Net::HTTP.new(lightUrl.host, lightUrl.port)
                    lightHttp.use_ssl = true
                       
                        
                    lightReq = Net::HTTP::Post.new(lightUrl.request_uri, 'Content-Type' => 'application/json')
                    lightReq['Authorization'] = 'Bearer ' + token
                    lightReq.body = listToSend.to_json
        
                    response = lightHttp.request(lightReq)
                    puts response.body
                    case response.body
                    when "Lights Off"
                        flash[:success] = "Lights turned off!"
                    else
                        flash[:deny] = response.body
                    end
                end
            end
        end
        redirect_to listing_path(@listing)
    end
end