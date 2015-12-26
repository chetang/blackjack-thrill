require 'card'
class Game < ActiveRecord::Base
  attr_accessible :bet_amount, :card_sequence, :dealer_card_sequence, :is_won, :user_id, :state
  belongs_to :user
  serialize :card_sequence, Array 
  serialize :dealer_card_sequence, Array
	validates_inclusion_of :state, :in => [ "user_action", "dealer_action", 'over' ]
	validates_presence_of :bet_amount
  validates :bet_amount, :numericality => {:greater_than_or_equal_to => 50, :less_than_or_equal_to => 500}, :presence => true
  def cards_from_sequence(sequence)
    cards = ""
    unless sequence.blank?
      cards = sequence.map{|seq| Deck.identCard(seq)}
      cards = cards.join(", ")
    end
    return cards
  end

  def self.scoreHand(hand) #determines the score of the hand
    total=0
    aceCount=0
    hand.each  do |i|
      aceCount+=1 if i%13==1
      total+=Deck.getValue(i)
      while total>21 do
        if aceCount>0 then
         total = total-10
         aceCount-=1
        end #end if
        break if aceCount == 0
      end #end while     
    end #end do
    total 
  end #end scorehand

  def draw_card(draw_user_card = true)
    drawn_card_sequences = []
    drawn_card_sequences << self.card_sequence
    drawn_card_sequences << self.dealer_card_sequence
    drawn_card_sequences.flatten!
    deck =  (1..52).to_a.shuffle
    undrawn_cards = deck - drawn_card_sequences
    next_card = undrawn_cards.pop

    if draw_user_card
      self.card_sequence << next_card
    else
      self.dealer_card_sequence << next_card
    end
    self.update_game_status()
  end

  def update_game_status
  	user_cards = self.card_sequence
  	user_score = Game.scoreHand(user_cards)
  	if self.state == "user_action"
  		if user_score > 21
  			self.is_won = false
  			self.state = 'over'
  		end
  	elsif self.state == "dealer_action" # game state has been updated to 'dealer_action' when stand is called
  		dealer_cards = self.dealer_card_sequence
  		dealer_score = Game.scoreHand(dealer_cards)
  		if dealer_score < 17
  			self.draw_card(false)
  		elsif dealer_score == 21
  			self.state = "over"
  			self.is_won = false
  		elsif dealer_score > 21
  			self.state = "over"
  			self.is_won = true
  		elsif dealer_score < 21 && dealer_score >= user_score
  			self.state = 'over'
  			self.is_won = false
  		elsif dealer_score < 21 && dealer_score < user_score
  			self.state = 'over'
  			self.is_won = true
  		end
  	end
		self.save!
  end

  def self.user_money_hash
    users_won_money_hash = Game.group(:user_id).where(:is_won => true).sum("bet_amount * 2")
    users_lost_money_hash = Game.group(:user_id).where(:is_won => false).sum("bet_amount * -1")
    users_net_money_hash = {}
    users_won_money_hash.merge(users_lost_money_hash){|k, old_v, new_v| old_v.to_i + new_v.to_i}.each_pair{|k,v| users_net_money_hash[k] = v.to_i}
    return users_net_money_hash    
  end
end
