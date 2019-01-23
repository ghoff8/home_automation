require 'bundler/setup'
require 'oauth2'
require 'json'
require "net/http"
require "uri"
class ConnectController < ApplicationController

    CLIENT_ID = '3ca4bb57-753a-42bf-8cea-aa5ace621132'
    CLIENT_SECRET = '0f941e3d-cacb-40f0-9ea6-e8d9b65da3e0'
    
    
    
    # helper method to know if we have an access token
    def authenticated?
          session[:access_token]
    end
    
    def index
       # enable :sessions
        #register Sinatra::Flash
    
        #before do
        #  @listings = Listings.new()
        #end
    
        # We'll store the access token in the session
        #use Rack::Session::Pool, :cookie_only => false
    
        # This is the URI that will be called with our access
        # code after we authenticate with our SmartThings account
        
        # This is the URI we will use to get the endpoints once we've received our token
        endpoints_uri = 'https://graph.api.smartthings.com/api/smartapps/endpoints'
        # handle requests to /authorize URL
        
    end
    
    # handle requests to /oauth/callback URL. We
    # will tell SmartThings to call this URL with our
    # authorization code once we've authenticated.
    def create
        options = {
          site: 'https://graph.api.smartthings.com',
          authorize_url: '/oauth/authorize',
          token_url: '/oauth/token'
        }
        redirect_uri = URI.parse(request.original_url)
        redirect_uri = "#{redirect_uri.scheme}://#{redirect_uri.host}" + "/oauth/callback"
        client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, options)
        url = client.auth_code.authorize_url(code: CLIENT_SECRET, client_id: CLIENT_ID, redirect_uri: redirect_uri, scope: 'app')
        redirect_to url
        #"https://rabbu-app-ghoffma3.c9users.io/oauth/callback"
    end
    
    def authorize
        if (params[:error] == "access_denied")
            flash[:deny] = "Access Denied"
            redirect_to connect_index_path
            return
        end
        redirect_uri = URI.parse(request.original_url)
        redirect_uri = "#{redirect_uri.scheme}://#{redirect_uri.host}" + "/oauth/callback"
        
        codeToSend = params[:code]
        options = {
          site: 'https://graph.api.smartthings.com',
          authorize_url: '/oauth/authorize',
          token_url: '/oauth/token'
        }
        client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, options)
        # Use the code to get the token.
        response = client.auth_code.get_token(codeToSend, client_id: CLIENT_ID, client_secret: CLIENT_SECRET, redirect_uri: redirect_uri)
    
        # now that we have the access token, we will store it in the session
        session[:access_token] = response.token
        
        # debug - inspect the running console for the
        # expires in (seconds from now), and the expires at (in epoch time)
        puts 'TOKEN EXPIRES IN ' + response.expires_in.to_s
        puts 'TOKEN EXPIRES AT ' + response.expires_at.to_s
        redirect_to listings_path
    end
    # handle requests to the /getSwitch URL. This is where
    # we will make requests to get information about the configured
    # switch.
    #get '/getDevices' do
      # If we get to this URL without having gotten the access token
      # redirect back to root to go through authorization
    #  if !authenticated?
    #    redirect '/'
    #  end
    
    #  token = session[:access_token]
    
      # make a request to the SmartThings endpoint URI, using the token,
      # to get our endpoints
    #  url = URI.parse(endpoints_uri)
    #  req = Net::HTTP::Get.new(url.request_uri)
    
      # we set a HTTP header of "Authorization: Bearer <API Token>"
    #req['Authorization'] = 'Bearer ' + token
    
    #  http = Net::HTTP.new(url.host, url.port)
    #  http.use_ssl = (url.scheme == "https")
    
    #  response = http.request(req)
    #  json = JSON.parse(response.body)
      
      # get the endpoint from the JSON:
    #  uri = json[0]['uri']
    #  erb :index
    #    end
    #end
end
