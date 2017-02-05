require 'trello'
require 'config_env'

class LoginToTrello

  ConfigEnv.init('config/config_env.rb')

  def call
    Trello.configure do |config|
      config.developer_public_key = ENV['TRELLO_APP_KEY'] # The "key" from step 1
      config.member_token = ENV['TRELLO_APP_TOKEN'] # The token from step 3.
    end
    me = Trello::Member.find("cesarordonezhn")
  end
end
