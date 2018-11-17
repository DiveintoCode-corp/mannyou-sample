class AddColumnImageToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :image, :string, null: false, default: ''
  end
end
