class CreateLabelings < ActiveRecord::Migration[5.2]
  def change
    create_table :labelings do |t|
      t.references :task, index: true, null: false
      t.references :label, index: true, null: false
    end
  end
end
