class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string :name
      t.integer :credits
      t.decimal :one_month, :two_months, :three_months, :precision => 6, :scale => 2, :default => '0.00'
      t.integer :limit
      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
