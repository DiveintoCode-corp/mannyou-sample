class Label < ApplicationRecord
  belongs_to :user, optional: true
  has_many :labelings, dependent: :destroy
  has_many :labeling_tasks, through: :labelings, source: :task

  scope :can_use, -> (user) { where(user_id: nil).or(Label.where(user_id: user)) }

  def self.chat_date_extraction
    chat_labels = []
    where(user_id: nil).each do |label|
      chat_label = [label.name, Labeling.where(label_id: label.id).count]
      chat_labels << chat_label
    end
    chat_labels
  end
end
