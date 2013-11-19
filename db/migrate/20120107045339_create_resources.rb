class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :name
      t.string :short_name
      t.decimal :peak_credits, :off_peak_credits, :precision => 3, :scale => 2, :default => 0.00
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
