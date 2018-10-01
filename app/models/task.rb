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
end
