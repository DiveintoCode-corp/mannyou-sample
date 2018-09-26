class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false, default: "", limit: 50
      t.string :email, null: false, default: "", limit: 500
      t.string :password_digest, null: false
      t.boolean :admin, null: false, default: false

      t.timestamps
    end
  end
end
