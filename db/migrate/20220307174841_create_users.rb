class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :nickname
      t.text :token

      t.timestamps
    end
    
    add_index :users, :email, unique: true
    add_index :users, :nickname, unique: true
  end
end
