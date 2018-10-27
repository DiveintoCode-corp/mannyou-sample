class Read < ApplicationRecord
  belongs_to :user
  belongs_to :task

  def self.already?(user, task)
    where(user_id: user.id).find_by(task_id: task.id).present?
  end
end
