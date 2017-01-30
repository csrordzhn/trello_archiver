require 'trello'
require 'config_env'

ConfigEnv.init('config/config_env.rb')

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_APP_KEY'] # The "key" from step 1
  config.member_token = ENV['TRELLO_APP_TOKEN'] # The token from step 3.
end

me = Trello::Member.find("cesarordonezhn")

team = Trello::Organization.find("dev_test")

board = team.boards.first # get the boards from this team
lists = board.lists # get the lists from the board

cards = lists.map do |l|
  l.cards.each do |c| c.id end
end

cards_2 = cards.flatten
card_ids = cards_2.map { |c| c.id }

# 1) classify

card_ids.each do |c|
  card = Trello::Card.find(c)
  proy_label = card.name.last(5).upcase
  exists = card.labels.keep_if {|lb| lb.name == proy_label }
  lbl_color="sky" # depends on the list
  new_label = Trello::Label.create({name:proy_label, board_id:card.board_id, color: lbl_color}) if exists.count == 0
  card.add_label(new_label)
end


# 2) send email to list owner

# for each list get an array of cards with their status
# prepare message text
# send message string to list owner

# find the complete labels


lists.each do |l|
  completed = l.cards.keep_if do |c| is_card_complete(c.labels) end
    puts completed.count
end

def is_card_complete(card_labels)
  team = Trello::Organization.find("dev_test")
  board = team.boards.first
  complete_label = board.labels.keep_if {|l| l.name == "Complete" }.first.id
  card_labels.flatten!
  card_labels.include? complete_label
end

# 3) close cards
card_ids.each do |c|
  card = Trello::Card.find(c)
  is_complete = card.labels.keep_if { |lb| lb.name == "Complete" }
  card.close! if is_complete.count >= 1
end




# 2) send email to owner list
# send summary email
