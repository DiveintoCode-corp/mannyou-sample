class RemoveColumnReadAtToTasks < ActiveRecord::Migration[5.2]
  def up
    remove_column :tasks, :read_at
  end

  def down
    add_column :tasks, :read_at, :boolean, null: false, default: false
  end
end
