class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.references :user, :membership, :resource
      t.decimal :credits, :precision => 5, :scale => 3, :default => '0.00'
      t.datetime :start, :end
      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end
