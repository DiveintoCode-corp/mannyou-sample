User.create!(name: "tester", email: "test@gmail.com", password: "199392", admin: true)

1000.times do |i|
  Task.create!(title: "a_#{i}",
               content: "test_data",
               expired_at: Date.today,
               status: [0,1,2].sample,
               priority: [0,1,2].sample,
               user_id: User.all.sample.id
              )
end