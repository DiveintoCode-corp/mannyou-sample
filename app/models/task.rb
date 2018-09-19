class Task < ApplicationRecord
  belongs_to :user

  enum status: { 未着手: 0, 着手中: 1, 完了: 2 }
  enum priority: { 低: 0, 中: 1, 高: 2 }

  validates :title,  presence: true, length: { maximum: 500 }
  validates :content,  presence: true, length: { maximum: 30000 }
end
