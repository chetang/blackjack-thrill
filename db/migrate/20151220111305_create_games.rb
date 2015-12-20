class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :user_id
      t.boolean :is_won
      t.text :card_sequence
      t.text :dealer_card_sequence
      t.integer :bet_amount

      t.timestamps
    end
    add_index :games, :user_id
  end
end
