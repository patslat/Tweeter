require 'launchy'
require 'oauth'
require 'yaml'


# Request token URL  https://api.twitter.com/oauth/request_token
# Authorize URL  https://api.twitter.com/oauth/authorize
# Access token URL  https://api.twitter.com/oauth/access_token

class TwitterSession
  #CONSUMER_KEY = ## insert consumer key here
  #CONSUMER_SECRET = ## insert consumer_secret here

  CONSUMER = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")
  @@access_token = nil

  def self.get_access_token
    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url
    puts "Log in and enter your PIN"
    Launchy.open(authorize_url)

    oauth_verifier = gets.chomp

    @@access_token = request_token.get_access_token(
      :oauth_verifier => oauth_verifier)
  end

  def self.auth_token
    @@access_token ||= get_access_token
  end
end