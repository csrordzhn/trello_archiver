require 'trello'
require 'config_env'

ConfigEnv.init('config/config_env.rb')

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_APP_KEY'] # The "key" from step 1
  config.member_token = ENV['TRELLO_APP_TOKEN'] # The token from step 3.
end

me = Trello::Member.find("cesarordonezhn")

# puts "You have #{me.boards.count} boards on Trello" # returns array. Method count returns how many boards

# get the boards from work.

# puts "You have #{me.organizations.count} teams on Trello" # returns array. Method count returns how many boards

#me.organizations.each do |o|
#    o.boards.each do |b|
#      puts "#{b.name} belongs to #{o.name}"
#    end
#  end

# archive completed cards in a boards

team = Trello::Organization.find("dev_test")


board = team.boards.first # get the boards from this team
lists = board.lists # get the lists from the board

cards = lists.map do |l|
  l.cards.each do |c| c.id end
end

cards_2 = cards.flatten

card_ids = cards_2.map { |c| c.id }

card_ids.each do |c|
  card = Trello::Card.find(c)
  #puts card.name
  is_complete = card.labels.keep_if { |lb| lb.name == "Complete" }
  card.close! if is_complete.count >= 1
end
#cards = lists.map {|l| l.card} # get the cards from the lists

#puts team.name

# works
# my_board = Trello::Board.find("Dev_Board")

#lists_in_my_board = my_board.lists

#puts lists_in_my_board.class

# works, longer
#board = team.boards.keep_if do |b|
#  b.name == "Dev_Board"
#end

#puts board.count
#puts board.first.has_lists?

#lists_in_my_board.each do |list|
#  list.cards.each do |card|
#    card.close! if card.powerup.checked
#  end
#end
