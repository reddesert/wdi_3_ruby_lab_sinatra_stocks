require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'yahoofinance'
require 'dotenv'
require 'twitter'
require 'pg'

Dotenv.load
set :server, 'webrick'

def run_sql(sql)
  db = PG.connect(dbname: 'address_book', host: 'localhost')
  result = db.exec(sql)
  db.close
  result
end

get '/people' do
  @people = run_sql("SELECT * FROM people")
  erb :people
end

post '/people' do
  name, phone = params[:name], params[:phone]
  run_sql("INSERT INTO people (name, phone) VALUES ('#{name}','#{phone}')")
  redirect to '/people'
end


def twitter_client
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACCESS_TOKEN"]
    config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
  end
end

get '/twitter/:username' do
  @user = params[:username]
  @tweets = twitter_client.user_timeline(@user)
  erb :tweets
end

# get '/' do
#   erb :quote
# end