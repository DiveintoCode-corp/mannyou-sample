require 'rails_helper'

RSpec.feature "ラベル機能", type: :feature do
  user = FactoryBot.create(:user)
  task = FactoryBot.create(:task, user: user)
  FactoryBot.create(:another_task, user: user)
  label = FactoryBot.create(:label)
  user_created_label = FactoryBot.create(:user_created_label, user: user)
  FactoryBot.create(:labeling, task: task, label: label)
  FactoryBot.create(:labeling, task: task, label: user_created_label)

  feature "個々のラベル機能のテスト" do
    background do
      visit root_path

      fill_in 'Email', with: 'shibata@example.com'
      fill_in 'Password', with: '123456'
      click_on 'ログインする'

      expect(page).to have_content 'tester_0000'
    end

    scenario "ラベル一覧のテスト" do
      visit tasks_path

      all('tr td')[16].click_link '詳細'
      expect(page).to have_content 'title'
      expect(page).to have_content 'default_one'
      expect(page).to have_content 'user_has_one'
    end

    scenario "自作ラベル新規作成のテスト" do
      visit new_label_path

      fill_in 'ラベル名', with: 'テストラベル'
      click_on '登録する'

      expect(page).to_not have_content 'default_one'
      expect(page).to have_content 'テストラベル'
      expect(page).to have_content 'user_has_one'
    end

    scenario "自作ラベル編集のテスト" do
      visit edit_label_path(user_created_label.id)

      fill_in 'ラベル名', with: '編集ラベル'
      click_on '更新する'

      visit labels_path

      expect(page).to have_content '編集ラベル'
      expect(page).to_not have_content 'user_has_one'
    end

    scenario "ラベル検索のボタンで、指定のラベルを選択して押すと、検索条件に一致するもののみが出るかのテスト" do
      visit tasks_path
      expect(page).to have_content 'another_title'
      expect(page).to have_content 'title'

      select 'default_one', from: 'task_label_id'
      click_on '検索する'

      expect(page).to have_content 'title'
    end

    scenario "ラベル付け外しのテスト" do
      visit edit_task_path(task.id)

      check 'task_label_ids_1'
      uncheck 'task_label_ids_2'
      click_on '更新する'

      visit task_path(task.id)

      expect(page).to have_content 'title'
      expect(page).to have_content 'default_one'
      expect(page).not_to have_content 'user_has_one'
    end
  end
 end

