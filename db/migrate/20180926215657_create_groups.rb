class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name, null: false, default: "", limit: 300
      t.text :description, null: false, default: "", limit: 10000
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
