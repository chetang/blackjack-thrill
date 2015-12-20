class AddColumnStateToGame < ActiveRecord::Migration
  def change
    add_column :games, :state, :string, default: 'user_action'
  end
end
