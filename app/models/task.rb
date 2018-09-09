class Task < ApplicationRecord
  validates :title,  presence: true, length: { maximum: 500 }
  validates :content,  presence: true, length: { maximum: 30000 }
end
