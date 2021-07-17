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
  public_repos = user.public_repos

  following = client.following
  length = following.length()

  erb :leaderboard, :locals => {:avatar_url => avatar, :login => user_login, :followers => followers, :following => following, :public_repos => public_repos}
end
