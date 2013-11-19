class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.references :user, :plan
      t.integer :credits
      t.date :start
      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end
