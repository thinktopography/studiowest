class AddTermOfUsage < ActiveRecord::Migration

  def self.up
    add_column :users, :agreed_to_terms, :boolean, :default => 0
  end

  def self.down
    remove_column :users, :agreed_to_terms
  end

end