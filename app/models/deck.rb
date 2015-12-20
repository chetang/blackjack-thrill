module Deck

  def Deck.getValue(card)# This function takes a card as a parameter and returns the value of that card
    case card%13
      when 0,11,12 then return 10
      when 1 then return 11 
      else return card%13
      end #end case
  end #end getValue 

  def Deck.identCard(card) #given a card numb(1..52) identifies the face and suit of that card
    suit = (case (card-1)/13
            when 0 then " of hearts"
            when 1 then " of clubs"
            when 2 then " of diamonds"
            when 3 then " of spades"
            else raise StandardError
            end)  #end case
    case card%13
      when 1 then return "Ace" + suit
      when 11 then return "Jack" + suit
      when 12 then return "Queen" + suit
      when 0 then return "King" + suit
      else return (card%13).to_s + suit
    end #end case
  end #end identCard

end