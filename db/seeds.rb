1000000.times do |i|
  Task.create!(title: "a_#{i}", content: "test_data", expired_at: Date.today, status: [0,1,2].sample)
end