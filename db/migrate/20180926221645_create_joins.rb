class CreateJoins < ActiveRecord::Migration[5.2]
  def change
    create_table :joins do |t|
      t.references :user, index: true, null: false
      t.references :group, index: true, null: false

      t.timestamps
    end
  end
end
