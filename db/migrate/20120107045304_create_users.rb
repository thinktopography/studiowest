class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table(:users) do |t|
      t.string :first_name, :last_name, :email
      t.references :code
      t.string :avatar_file_name
      t.integer :avatar_file_size
      t.string :avatar_content_type
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.confirmable
      t.token_authenticatable
    end
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    drop_table :users
  end
  
end