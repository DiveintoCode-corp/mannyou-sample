FactoryBot.define do
  factory :user do
    name { 'tester_0000' }
    email { 'shibata@example.com' }
    password { '123456' }
  end

  factory :another_user, class: User do
    name { 'another_0000' }
    email { 'another@example.com' }
    password { '123456' }
  end

  factory :admin_user, class: User do
    name { 'admin_0000' }
    email { 'admin@example.com' }
    admin { true }
    password { '123456' }
  end
end
