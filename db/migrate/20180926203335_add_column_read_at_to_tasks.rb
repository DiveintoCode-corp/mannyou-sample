class AddColumnReadAtToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :read_at, :boolean, null: false, default: false
  end
end
