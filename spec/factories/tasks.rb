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
end
