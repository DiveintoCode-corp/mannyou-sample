class Join < ApplicationRecord
  belongs_to :user
  belongs_to :group

  scope :to_match, -> (user, group) { where(user_id: user.id).find_by(group_id: group.id) }
end
