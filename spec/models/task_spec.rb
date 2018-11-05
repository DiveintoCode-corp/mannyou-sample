require 'rails_helper'

RSpec.describe Task, type: :model do
  user = FactoryBot.create(:user)

  describe "titleとcontentのバリデーション" do
    it "titleが空ならバリデーションが通らない" do
      task = Task.new(title: '', content: '失敗テスト', user_id: user.id)
      expect(task).not_to be_valid
    end

    it "contentが空ならバリデーションが通らない" do
      task = Task.new(title: '失敗テスト', content: '', user_id: user.id)
      expect(task).not_to be_valid
    end

    it "titleとcontentに内容が記載されていればバリデーションが通る" do
      task = Task.new(title: '成功', content: 'テスト', user_id: user.id)
      expect(task).to be_valid
    end

    it "titleが500文字を超えていたらバリデーションが通らない" do
      words = 'a' * 501
      task = Task.new(title: "#{words}", content: '失敗テスト', user_id: user.id)
      expect(task).not_to be_valid
    end

    it "contentが30000文字を超えていたらバリデーションが通らない" do
      words = 'a' * 30001
      task = Task.new(title: '失敗テスト', content: "#{words}", user_id: user.id)
      expect(task).not_to be_valid
    end
  end

  describe "titleとstatusの検索（絞り込み）機能のテスト" do
    before do
      FactoryBot.create(:task, title: 'testtesttest', status: Task::statuses["未着手"], user: user)
      FactoryBot.create(:task, title: 'test', status: Task::statuses["着手中"], user: user)
      FactoryBot.create(:task, title: 'samplesample', status: Task::statuses["着手中"], user: user)
    end

    it "title検索で「test」と検索すると、titleに「test」を含むTaskを二つ返す" do
      expect(Task.title_search('test').count).to eq 2
      expect(Task.title_search('test').pluck(:title)).to eq ['testtesttest','test']
    end

    it "状態検索で「着手中」（indexの'1'）を選択すると、「着手中」のTaskを二つ返す" do
      expect(Task.status_search(Task::statuses["着手中"]).count).to eq 2
      expect(Task.status_search(1).pluck(:status)).to eq ["着手中", "着手中"]
    end
  end
end