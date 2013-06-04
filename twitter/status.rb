require 'addressable/uri'
require 'rest-client'
require 'json'
require 'nokogiri'
require 'pp'
require_relative 'twitter_session'

class Status
  attr_accessor :username, :status

  def initialize(author, message)
    @username = author
    @status = message
  end

  def self.parse(json)
    statuses = JSON.parse(json)
    status_objects = statuses.map do |status|
      Status.new(status["user"]["screen_name"], status["text"])
    end
    pp status_objects

  end

  def post
    query = Addressable::URI.new(
      :scheme       => "https",
      :host         => "api.twitter.com",
      :path         => "/1.1/statuses/update.json",
      :query_values => { screen_name: @username, status: @status }
    ).to_s

    TwitterSession.auth_token.post(query)

  end




end