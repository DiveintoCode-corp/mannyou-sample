class Read < ApplicationRecord
  belongs_to :user
  belongs_to :task

  def already?(user, task)
    Read.where(user_id: user.id).find_by(task_id: task.id).present?
  end
end
