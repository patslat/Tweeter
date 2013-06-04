require_relative 'user'
class EndUser < User

  def initialize(username)
    super(username)
    @@current_user = self
  end

  def self.me
    @@current_user
  end

  def self.set_user_name(username)
    @@current_user.username = username
  end

  def post_status(status_text)
    s = Status.new(username, status_text)
    s.post
  end

  def direct_message(other_user, text)
    #https://api.twitter.com/1.1/direct_messages/new.json
    query = Addressable::URI.new(
      :scheme       => "https",
      :host         => "api.twitter.com",
      :path         => "/1.1/direct_messages/new.json",
      :query_values => { screen_name: other_user, text: text }
    ).to_s
    p query
    TwitterSession.auth_token.post(query)
  end

end