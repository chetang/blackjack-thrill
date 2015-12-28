class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:games).all
    # respond_to :js
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    if session && session[:current_user_id]
      @user = User.find(session[:current_user_id])
    else
      @user = User.new
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # POST /users
  # POST /users.json
  def create
    email = params[:user][:email]
    @user = User.find_by_email(email)
    if @user.nil?
      @user = User.create(email: email)
      @user.save!
    end
    session[:current_user_id] = @user.id
    redirect_to controller: 'games', action: 'new', game: {user: @user}
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if params[:user][:email]
      @user = User.find_by_email(params[:user][:email])
      if @user.nil?
        @user = User.create(email: params[:user][:email])
        @user.save!
      end
    else
      @user = User.find(params[:id])
    end
    session[:current_user_id] = @user.id
    redirect_to controller: 'games', action: 'new', game: {user: @user}
  end

  def card_frequency
    user_game_count_hash = Game.group(:user_id).where(:state => 'over').count
    user_id = user_game_count_hash.key(user_game_count_hash.values.max)
    cards = Game.joins(:user).where(games:{user_id:user_id}).pluck(:card_sequence).flatten.sort
    @counts = Hash.new(0)
    cards.each { |card| @counts[Card.new(card).name] += 1 }
    @counts
  end

  def most_money
    users_net_money_hash = Game.user_money_hash
    max_net_profit = users_net_money_hash.values.map{|a| a.to_i}.max
    user_id = users_net_money_hash.key(max_net_profit.to_s)
    if user_id && max_net_profit
      @object = {max_net_profit => user_id}
    else
      @object = nil
    end
  end

  def each_user_profit
    @users_net_money_hash = Game.user_money_hash
  end

  def casino_profit
    @profit = Game.casino_balance
  end

  def no_game
    @inactive_users = User.where('id NOT IN (SELECT DISTINCT(user_id) FROM games)').select('email')
  end
end
