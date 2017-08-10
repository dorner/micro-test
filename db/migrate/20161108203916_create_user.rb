class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer       "vendor_id"
      t.integer       "merchant_id"
      t.integer       "partner_id"
      t.string        "name"
      t.string        "login",                 null: false
      t.string        "email"
      t.string        "uid"
      t.string        "type",                  null: false
      t.timestamps
    end

    add_index :users, :login, :unique => true
  end

end
