# このrequireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしています
require 'rails_helper'

# このRSpec.featureの右側に、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "タスク管理機能", type: :feature do
  background do
    user = FactoryBot.create(:user)

    # あらかじめタスク一覧のテストで使用するためのタスクを四つ作成する
    FactoryBot.create(:task, title: 'search_test', content: 'testtesttest', expired_at: Time.zone.today + 3, status: Task::statuses["未着手"], user: user)
    FactoryBot.create(:task, content: 'ponponpon', expired_at: Time.zone.today + 10, status: Task::statuses["未着手"], priority: Task::priorities["高"], user: user)
    FactoryBot.create(:task, content: 'mofmofmofmof', expired_at: Time.zone.today + 5, status: Task::statuses["着手中"], priority: Task::priorities["中"], user: user)
    FactoryBot.create(:task, content: 'samplesample', expired_at: Time.zone.today + 1, status: Task::statuses["完了"], user: user)
  end

  feature "個々のタスク機能のテスト" do
    background do
      # トップページを開く
      visit root_path
      # ログインフォームにnameとEmailとパスワードを入力する
      fill_in 'Email', with: 'shibata@example.com'
      fill_in 'Password', with: '123456'
      # ログインボタンをクリックする
      click_on 'ログインする'
      # ログインに成功し、ユーザー詳細ページに移行したことを検証する
      expect(page).to have_content 'tester_0000'
    end

    # scenarioの中に、確認したい各項目のテストの処理を書く
    scenario "タスク一覧のテスト" do
      # tasks_pathにvisitする（タスク一覧ページに遷移する）
      visit tasks_path

      # visitした（到着した）expect(page)に（タスク一覧ページに）「testtesttest」「mofmofmofmof」「samplesample」という文字列が
      # have_contentされているか？（含まれているか？）ということをexpectする（確認・期待する）テストを書いている
      expect(page).to have_content 'testtesttest'
      expect(page).to have_content 'mofmofmofmof'
      expect(page).to have_content 'samplesample'
    end

    scenario "タスク作成のテスト" do
      # new_task_pathにvisitする（タスク登録ページに遷移する）
      visit new_task_path

      # 「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄に
      # タスクのタイトルと内容をそれぞれfill_in（入力）する
      fill_in 'タスク名', with: '最初のタスク'
      fill_in 'タスク詳細', with: 'テスト書くぞテスト書くぞテスト書くぞ'

      # 「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）
      click_on '登録する'

      # clickで登録されたはずの情報と、登録を知らせるフラッシュメッセージが、タスク一覧ページに表示されているかを確認する
      # （タスクが登録されたらタスク一覧画面に遷移されるという前提）
      expect(page).to have_content 'タスク情報を登録しました'
      expect(page).to have_content 'テスト書くぞテスト書くぞテスト書くぞ'
    end

    scenario "タスク詳細のテスト" do
      visit tasks_path

      all('tr td')[6].click_link '詳細'
      expect(page).to have_content 'タスク詳細'
      expect(page).to have_content 'samplesample'
    end

    scenario "タスクが作成日時の降順に並んでいるかのテスト" do
      visit tasks_path
      all('tr td')[6].click_link '詳細'
      expect(page).to have_content 'samplesample'

      visit tasks_path
      all('tr td')[16].click_link '詳細'
      expect(page).to have_content 'mofmofmofmof'

      visit tasks_path
      all('tr td')[26].click_link '詳細'
      expect(page).to have_content 'ponponpon'
    end

    scenario "終了期限のソートボタンを押すと期限日時の降順に並ぶかのテスト" do
      visit tasks_path
      click_link 'タスクを終了期限順に並び替える'
      all('tr td')[6].click_link '詳細'
      expect(page).to have_content 'samplesample'

      visit tasks_path
      click_link 'タスクを終了期限順に並び替える'
      all('tr td')[16].click_link '詳細'
      expect(page).to have_content 'testtesttest'

      visit tasks_path
      click_link 'タスクを終了期限順に並び替える'
      all('tr td')[26].click_link '詳細'
      expect(page).to have_content 'mofmofmofmof'
    end

    scenario "title検索のボタンを押すと検索条件に一致するもののみが出るかのテスト" do
      visit tasks_path
      fill_in 'task_title', with: 'search'
      click_on '検索する'
      expect(page).to have_content 'search_test'
      expect(page).to_not have_content 'samplesample'
    end

    scenario "状態検索のボタンを「未着手」を選択して押すと、検索条件に一致するもののみが出るかのテスト" do
      visit tasks_path
      select '未着手', from: 'task_status'
      click_on '検索する'
      expect(page).to have_content 'search_test'
      expect(page).to have_content 'ponponpon'
      expect(page).to_not have_content 'samplesample'
    end

    scenario "状態検索のボタンを「未着手」とtitle検索のボタンを押すと検索条件に一致するもののみが出るかのテスト" do
      visit tasks_path
      fill_in 'task_title', with: 'search'
      select '未着手', from: 'task_status'
      click_on '検索する'
      expect(page).to have_content 'search_test'
      expect(page).to_not have_content 'ponponpon'
    end

    scenario "優先順位順に並び替えるリンクを踏むと優先順位の高い順に並び替わるかのテスト" do
      visit tasks_path
      click_link 'タスクを優先順位順に並び替える'
      all('tr td')[6].click_link '詳細'
      expect(page).to have_content 'ponponpon'

      visit tasks_path
      click_link 'タスクを優先順位順に並び替える'
      all('tr td')[16].click_link '詳細'
      expect(page).to have_content 'mofmofmofmof'
    end
  end
end