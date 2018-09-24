class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.string :name, null: false, default: "", limit: 100
      t.references :user, index: true
      t.boolean :default, null: false, default: true
    end
  end
end
