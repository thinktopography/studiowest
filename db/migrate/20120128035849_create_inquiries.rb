class CreateInquiries < ActiveRecord::Migration
  def self.up
    create_table :inquiries do |t|
      t.string :first_name, :last_name, :email, :phone
      t.timestamps
    end
  end

  def self.down
    drop_table :inquiries
  end
end
