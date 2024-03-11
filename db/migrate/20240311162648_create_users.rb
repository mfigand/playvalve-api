class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :idfa, null: false
      t.integer :ban_status, null: false

      t.timestamps
    end

    add_index :users, :idfa, unique: true
    add_index :users, :ban_status
  end
end
