class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, default: "", limit: 500
      t.text :content, null: false, default: "", limit: 30000

      t.timestamps
    end
  end
end
