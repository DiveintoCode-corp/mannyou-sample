class Label < ApplicationRecord
  belongs_to :user, optional: true
  has_many :labelings, dependent: :destroy
  has_many :labeling_tasks, through: :labelings, source: :task

  scope :can_use, -> (user) { where(user_id: nil).or(Label.where(user_id: user)) }
end
