class AddDateColumnExpiredAtToTasks < ActiveRecord::Migration[5.2]
  def change
    # psqlではカラムの順番を書き換えられないみたいなので、after: :contentは泣く泣く妥協（SQLを直接実行する方法はさすがにしんどい）
    add_column :tasks, :expired_at, :date, null: false, after: :content, default: -> { 'NOW()' }
  end
end
