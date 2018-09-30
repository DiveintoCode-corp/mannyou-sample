namespace :announcement_mail do
  desc "期限一週間かつ完了以外のTaskを所有しているUserにメール送信する"
  task expired_task: :environment do
    User.includes(:tasks).each do |user|
      tasks = user.tasks.limit(50).where(status: [0, 1]).where(expired_at: Time.zone.today..(Time.zone.today + 7)).order(:expired_at)
      TaskMailer.task_mail(user, tasks).deliver if tasks.present?
      p "#{user.name}さんにTask告知のメールを送信しました！" if tasks.present?
    end
  end
end
