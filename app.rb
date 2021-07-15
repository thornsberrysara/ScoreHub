require 'sinatra'
require 'dotenv'

Dotenv.load('./.env')

get '/' do
  erb :index, :locals => {:client_id => ENV["CLIENT_ID"]}
end