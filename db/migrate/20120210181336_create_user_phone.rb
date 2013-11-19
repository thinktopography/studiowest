class CreateUserPhone < ActiveRecord::Migration

  def self.up
    add_column :users, :phone, :string
    add_column :users, :is_approved, :boolean, :default => 0
  end

  def self.down
    remove_column :users, :phone
    remove_column :users, :is_approved
  end

end