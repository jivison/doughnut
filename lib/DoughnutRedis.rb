require 'redis'

class DoughnutRedis
  def initialize
    @client = Redis.new
  end

  def save_token(token)
    @client.set(get_token_key(token.token), token.to_json_private)
  end

  def get_token(token_string)
    json = @client.get(get_token_key(token_string))

    return nil unless json

    stored_token = JSON.parse json

    Token.new(token_string, stored_token['code'], stored_token['discord_id'])
  end

  def destroy_token(token_string)
    @client.del get_token_key(token_string)
  end

  private

  def get_token_key(token_string)
    "doughnut:token-#{token_string}"
  end
end
