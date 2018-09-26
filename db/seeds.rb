User.create!(name: "tester_admin", email: "test_admin_#{[*1..1000].sample}@gmail.com", password: "199392", admin: true)

10.times do |i|
  User.create!(name: "tester_#{i}",
               email: "test_#{i}_#{[*1..1000].sample}@gmail.com",
               password: "199392",
  )
end

50.times do |i|
  Task.create!(title: "a_#{i}",
               content: "test_data",
               expired_at: (Date.today + [*-30..60].sample),
               status: [0,1,2].sample,
               priority: [0,1,2].sample,
               user_id: User.all.sample.id
              )
end

test_labels = ['仕事', '宿題', 'ルーチン', '日課', 'スカンクワーク', '趣味', '勉強', '運動']

10.times do |i|
  Label.create!(name: "#{test_labels.sample}_#{i}_#{[*1..1000].sample}")
end

# ややこいので一旦ペンディング
# 20.times do |i|
#   Label.create!(name: "#{test_labels.sample}_#{i + 10}_#{[*1..1000].sample}", default: false, user_id: User.all.sample.id)
# end

200.times do
  labeling = Labeling.new(task_id: Task.all.sample.id, label_id: Label.all.sample.id)
  labeling.save! if Labeling.where(task_id: labeling.task_id).where(label_id: labeling.label_id).blank?
end
