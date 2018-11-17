class Group < ApplicationRecord
  belongs_to :user

  has_many :joins, dependent: :destroy
  has_many :join_users, through: :joins, source: :user

  def has_tasks
    join_users.includes(:tasks).map(&:tasks).flatten
  end

  def has_this_task?(user, task)
    Task.possessed_groups_of(user).ids.include?(task.id)
  end
end
