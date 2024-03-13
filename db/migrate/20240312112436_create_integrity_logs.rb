class CreateIntegrityLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :integrity_logs do |t|
      t.string :idfa, null: false
      t.integer :ban_status, null: false, default: 0
      t.string :ip, null: false
      t.string :rooted_device
      t.string :country
      t.string :proxy
      t.string :vpn

      t.timestamps
    end

    add_index :integrity_logs, :idfa
    add_index :integrity_logs, :ban_status
    add_index :integrity_logs, :ip
  end
end
