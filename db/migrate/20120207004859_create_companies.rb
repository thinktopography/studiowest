class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.text :description
      t.string :email
      t.string :website
      t.string :facebook
      t.string :twitter
      t.string :logo_file_name
      t.integer :logo_file_size
      t.string :logo_content_type
      t.boolean :is_enabled
      t.timestamps
    end
    add_column :users, :company_id, :integer
  end

  def self.down
    drop_table :companies
  end
end
