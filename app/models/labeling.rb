class Labeling < ApplicationRecord
  belongs_to :task
  belongs_to :label

  enum check: { not: 0 }

  scope :exists_in_combination, -> (label_id, task_id) { where(task_id: task_id).find_by(label_id: label_id) }

  def self.peel_off!(labels, task, checked_label_ids)
    labels.ids.each do |has_label_id|
      active_label = exists_in_combination(has_label_id, task.id)
      # すでにそのTaskに保存されているものかつ、編集画面でチェックの外されているラベルがあったらそれの中間テーブルのレコードを削除する
      active_label.destroy! unless checked_label_ids.include?(has_label_id.to_s) || active_label.blank?
    end
  end

  def self.paste_tasks!(label_ids, task)
    # ラベル（厳密にはTaskとLabelの中間テーブルであるラベリング）を複数保存する
    label_ids.each { |label_id| create!(task_id: task.id, label_id: label_id.to_i) if available?(label_id, task) }
  end

  def self.available?(label_id, task)
    !(label_id.to_i == checks[:not] || task.labeling_labels.ids.include?(label_id.to_i))
  end
end
