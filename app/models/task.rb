class Task < ApplicationRecord
  belongs_to :user

  has_many :labelings, dependent: :destroy
  has_many :labeling_labels, through: :labelings, source: :label
  has_many :reads, dependent: :destroy
  has_many :read_users, through: :reads, source: :user
  has_many_attached :files

  accepts_nested_attributes_for :labelings, allow_destroy: true, reject_if: :all_blank

  enum status: { 未着手: 0, 着手中: 1, 完了: 2 }
  enum priority: { 低: 0, 中: 1, 高: 2 }

  validates :title,  presence: true, length: { maximum: 500 }
  validates :content,  presence: true, length: { maximum: 30000 }

  scope :due_expire, -> (date) { where(expired_at: date) }
  scope :expire_warning, -> { where(status: [Task.statuses[:未着手], Task.statuses[:着手中]]).where(expired_at: Time.zone.today..(Time.zone.today + 7)) }
  scope :expire_danger, -> { where(status: [Task.statuses[:未着手], Task.statuses[:着手中]]).where("expired_at < ?", Time.zone.today) }
  scope :title_search, -> (title) { where("title LIKE ?", "%#{ title }%") }
  scope :status_search, -> (status) { where(status: status) }
  scope :label_search, -> (label_id) { where(id: Labeling.where(label_id: label_id).pluck(:task_id)) }
  scope :possessed_groups_of, -> (user) { where(user_id: user.join_groups.map(&:join_users).flatten.pluck(:id)) }
end
