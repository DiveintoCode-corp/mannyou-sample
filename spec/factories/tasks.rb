# 「FactoryBotを使用します」という記述
FactoryBot.define do

  # 作成するテストデータの名前を「task」とします
  # （実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを自動で作成します）
  factory :task do
    title { 'title' }
    content { 'content' }
    expired_at { Time.zone.today }
    status { Task::statuses["未着手"] }
    user
  end

  factory :another_task, class: Task do
    title { 'another_title' }
    content { 'another_content' }
    expired_at { Time.zone.today + 10 }
    status { Task::statuses["完了"] }
    user
  end
end
