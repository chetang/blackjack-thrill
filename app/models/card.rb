require 'deck'

class Card
  attr_accessor :value, :name

  def initialize(number)
    value = Deck.getValue(number)
    name = Deck.identCard(number)
    @value, @name = value, name
    Rails.logger.debug "Card: value=#{value}, name=#{name}"
  end



end