# 3) close cards
#card_ids.each do |c|
#  card = Trello::Card.find(c)
#  is_complete = card.labels.keep_if { |lb| lb.name == "Complete" }
#  card.close! if is_complete.count >= 1
#end
