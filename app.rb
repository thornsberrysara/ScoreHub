require 'sinatra'
require 'dotenv'
require 'rest-client'
require 'json'
require 'octokit'

Dotenv.load('./.env')

get '/' do
  erb :index, :locals => {:client_id => ENV["CLIENT_ID"]}
end

get '/leaderboard' do
  session_code = request.env['rack.request.query_hash']['code']

  response = RestClient.post('https://github.com/login/oauth/access_token',
    {:client_id => ENV["CLIENT_ID"],
    :client_secret => ENV["CLIENT_SECRET"],
    :code => session_code},
    :accept => :json)
  
  access_token = JSON.parse(response)['access_token']
  client = Octokit::Client.new(:access_token => access_token)
  
  user = client.user
  avatar = user.avatar_url
  user_login = user.login
  followers = user.followers
  repos_url = user.repos_url
  events_url = user.events_url
  followers_url = user.followers_url
  following_url = user.following_url

  following = client.following
  userData = following.collect { |item| {:login => item.login, :avatar_url => item.avatar_url, :repos_url => item.repos_url, :events_url => item.events_url, :followers_url => item.followers_url, :following_url => item.following_url} }.to_json

  erb :leaderboard, :locals => {:avatar_url => avatar, :login => user_login, :followers => followers, :following => following, :repos_url => repos_url, :events_url => events_url, :followers_url => followers_url, :following_url => following_url, :userData => userData}
end
