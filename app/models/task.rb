class Task < ApplicationRecord
  enum status: { 未着手: 0, 着手中: 1, 完了: 2 }

  validates :title,  presence: true, length: { maximum: 500 }
  validates :content,  presence: true, length: { maximum: 30000 }
end
