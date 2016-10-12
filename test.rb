require 'trello'
require 'config_env'

ConfigEnv.init('config/config_env.rb')

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_APP_KEY'] # The "key" from step 1
  config.member_token = ENV['TRELLO_APP_TOKEN'] # The token from step 3.
end

me = Trello::Member.find("cesarordonezhn")

puts "You have #{me.boards.count} boards on Trello" # returns array. Method count returns how many boards

# get the boards from work.
