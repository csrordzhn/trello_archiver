require 'trello'
require 'config_env'

ConfigEnv.init('config/config_env.rb')

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_APP_KEY'] # The "key" from step 1
  config.member_token = ENV['TRELLO_APP_TOKEN'] # The token from step 3.
end

# me = Trello::Member.find("someone")

team = Trello::Organization.find("dev_test")



board = team.boards.first # get the boards from this team
lists = board.lists # get the lists from the board
cards = lists.map do |l|
  l.cards.each do |c| c end
end

cards_2 = cards.flatten
card_ids = cards_2.map { |c| {id: c.id, name: c.name, labels: c.card_labels, board: c.board_id, list: c.list_id } }

cards_on_this_board = ["588951f97050f6e18e11b57c",
 "588951f5117f0baabfafd4b3",
 "588df87b5910ec63a52e2ca1",
 "589731951d9a2e819539b076",
 "58973199dbe2794c5645a28d",
 "5889526725c91105f81d4fd6",
 "589731a60aadf4f2bd758696"]



puts "This board has #{card_ids.count} Cards."

# 1) classify
# card_ids.each do |c|
#  card = Trello::Card.find(c)
#  proy_label = card.name.last(5).upcase
#  exists = card.labels.keep_if {|lb| lb.name == proy_label }
#  lbl_color="sky" # depends on the list
#  new_label = Trello::Label.create({name:proy_label, board_id:card.board_id, color: lbl_color}) if exists.count == 0
#  card.add_label(new_label)
# end


# 2) send email to list owner

# for each list get an array of cards with their status
# prepare message text
# send message string to list owner

# find the complete labels

def is_card_complete_a(label_array)
  # array of hashes
  return false if label_array.empty?
  arr = label_array.map do |lb|
    label_json = lb.as_json
  end

  completed_labels = arr.keep_if do |lb|
    lb.has_value?"Complete"
  end

  true if completed_labels.count >= 1
end

def is_card_complete_b(label_array)
  label_data = label_array.map do |l|
    label = Trello::Card.find(l)
    label.name
  end

  label_data.include? "Complete"

end

lists.each do |l|

    cards_in_list = l.cards.map { |c| c.id }

    #puts "Cards in list before selecting completed #{cards_in_list.count}"

    list_of_completed_cards = cards_in_list.take_while do |c|
      card = Trello::Card.find(c)
      is_card_complete_b(card.card_labels)
    end
    #puts "Cards in list after selecting completed #{cards_in_list.count}"
    # list_of_pending_cards = cards_in_list.select do |c|


    # send_message
    #puts "Summary Of Completed Cards"
    puts "This list has #{list_of_completed_cards.count} completed cards and #{cards_in_list.count} open cards."
    #list_of_completed_cards.each do |c|
    #  puts c.name
    #end

    #puts "Summary of Pending Cards"
    #puts cards_in_list.count
    #  puts c.name
    #end
    # close_pending_cards
  end
