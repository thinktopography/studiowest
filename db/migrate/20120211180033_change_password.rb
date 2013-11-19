class ChangePassword < ActiveRecord::Migration

  def self.up
    remove_column :users, :is_approved
    add_column :users, :change_password, :boolean, :default => 0
  end

  def self.down
    add_column :users, :is_approved, :boolean, :default => 0
    remove_column :users, :change_password
  end

end