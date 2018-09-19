User.create!(name: "tester_admin", email: "test_admin_#{[*1..1000].sample}@gmail.com", password: "199392", admin: true)

10.times do |i|
  User.create!(name: "tester_#{i}",
               email: "test_#{i}_#{[*1..1000].sample}@gmail.com",
               password: "199392",
  )
end

500.times do |i|
  Task.create!(title: "a_#{i}",
               content: "test_data",
               expired_at: Date.today,
               status: [0,1,2].sample,
               priority: [0,1,2].sample,
               user_id: User.all.sample.id
              )
end