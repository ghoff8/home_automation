require 'rubygems'
require 'sinatra'
require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Listing
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    property :timeCreated, DateTime
    property :devices, String
end

DataMapper.finalize

Device.auto_upgrade!
