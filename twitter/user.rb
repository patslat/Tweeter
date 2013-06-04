require 'addressable/uri'
require 'rest-client'
require 'json'
require 'nokogiri'
require 'pp'
require_relative 'twitter_session'
require_relative 'status'

class User
  attr_accessor :username
  def initialize(username)
    @username = username
  end

  def self.parse(json)
    JSON.parse(json)["users"].map do |user|
      User.new(user["screen_name"])
    end
  end

  def timeline
    #https://api.twitter.com/1.1/statuses/user_timeline.json
    query = Addressable::URI.new(
      :scheme       => "https",
      :host         => "api.twitter.com",
      :path         => "/1.1/statuses/user_timeline.json",
      :query_values => { screen_name: @username }
    ).to_s

    timeline = TwitterSession.auth_token.get(query)
    Status.parse(timeline.body)
  end

  def friends
    #https://api.twitter.com/1.1/friends/ids.json
    query = Addressable::URI.new(
      :scheme       => "https",
      :host         => "api.twitter.com",
      :path         => "/1.1/friends/list.json",
      :query_values => { screen_name: @username }
    ).to_s

    friends_list = TwitterSession.auth_token.get(query)

    User.parse(friends_list.body)
  end

  def followers
    #https://api.twitter.com/1.1/followers/ids.json
    query = Addressable::URI.new(
      :scheme       => "https",
      :host         => "api.twitter.com",
      :path         => "/1.1/followers/list.json",
      :query_values => { screen_name: @username }
    ).to_s

    followers_list = TwitterSession.auth_token.get(query)

    User.parse(followers_list.body)
  end

end

#https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=patslat4
#https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=twitterapi&count=2