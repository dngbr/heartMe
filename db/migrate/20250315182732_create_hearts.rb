class CreateHearts < ActiveRecord::Migration[8.0]
  def change
    create_table :hearts do |t|
      t.references :giver, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    
    # Add a unique index to prevent duplicate hearts
    add_index :hearts, [:giver_id, :receiver_id], unique: true
  end
end
