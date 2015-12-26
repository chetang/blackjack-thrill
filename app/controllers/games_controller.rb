class GamesController < ApplicationController
  # GET /games
  # GET /games.json

  def index
    if session && session[:current_user_id].present?
      current_user = User.find(session[:current_user_id])
      if current_user
        @games = Game.where(:user_id => current_user)
        @user = current_user
        return
      end
    else
      @user = nil
      @games = []
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    if @game.card_sequence.blank?
      @deck =  (1..52).to_a.shuffle
      @player_hand = []  #players initial hand
      @player_hand << @deck.pop
      @player_hand << @deck.pop

      @dealer_hand = []  #dealers initial hand
      @dealer_hand << @deck.pop
      @dealer_hand << @deck.pop

      @game.card_sequence = @player_hand
      @game.dealer_card_sequence = @dealer_hand
      @game.save!
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new
    if params[:game][:user]
      @game.user_id = params[:game][:user]
    elsif session && session[:current_user_id].present?
      @game.user_id = session[:current_user_id]
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])
    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  def draw_user_card
    @game = Game.find(params[:id])
    @game.draw_card(true) # This method is drawing a card for the user but doesn't save it
    unless @game.state == 'over'
      drawn_card = @game.card_sequence.last
      next_card = Card.new(drawn_card)
      @next_card_string = next_card.name + "(" + next_card.value.to_s + ")"
    end
  end

  def draw_dealer_card
    @game = Game.find(params[:id])
    @game.state = "dealer_action"
    @game.update_game_status()
    redirect_to game_path(@game)
  end
end
