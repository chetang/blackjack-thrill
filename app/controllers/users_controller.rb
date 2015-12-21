class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_to :js
    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render json: @users }
    # end
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
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    email = params[:user][:email]
    # throw "Nil email" if email.blank?
    @user = User.find_by_email(email)
    if @user.nil?
      @user = User.create(email: email)
      @user.save!
    end
    current_user=(@user)
    redirect_to controller: 'games', action: 'new', game: {user: @user}
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def login_user
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
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
    max_net_profit = users_net_money_hash.values.max
    user_id = users_net_money_hash.key(max_net_profit)
    @object = {max_net_profit => user_id}
  end

  def each_user_profit
    @users_net_money_hash = Game.user_money_hash
  end

  def casino_profit
    casino_win_loss_hash = Game.where('state = ?', 'over').group(:is_won).sum(:bet_amount)
    casino_win_loss_hash[false] ||= 0
    casino_win_loss_hash[true] ||= 0
    @profit = casino_win_loss_hash[false] - casino_win_loss_hash[true] * 2
  end

  def no_game
    @inactive_users = User.where('id NOT IN (SELECT DISTINCT(user_id) FROM games)').select('email')
  end
end
