class AddLowercaseEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_lower, :string
    add_index :users, :email_lower, unique: true
  end
end
