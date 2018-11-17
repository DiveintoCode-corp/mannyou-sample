FactoryBot.define do
  factory :label do
    name { 'default_one' }
    default { true }
  end

  factory :user_created_label, class: Label do
    name { 'user_has_one' }
    default { false }
    user
  end
end
