require 'rails_helper'

RSpec.feature "ユーザー機能", type: :feature do
  user = FactoryBot.create(:user)
  another_user = FactoryBot.create(:another_user)
  admin_user = FactoryBot.create(:admin_user)

  feature "個々のユーザー機能のテスト" do
    background do
      visit root_path

      fill_in 'Email', with: 'shibata@example.com'
      fill_in 'Password', with: '123456'
      click_on 'ログインする'

      expect(page).to have_content 'tester_0000'
    end

    scenario "ユーザー作成のテスト" do
      click_link 'ログアウト'
      visit new_user_path

      fill_in '名前', with: 'totono'
      fill_in 'メールアドレス', with: 'test_user@example.com'
      fill_in 'パスワード', with: '123456'
      fill_in 'パスワード（確認）', with: '123456'

      click_on '登録する'
      expect(page).to have_content 'totono'
    end

    scenario "ユーザー詳細のテスト" do
      visit user_path(user)

      expect(page).to have_content 'tester_0000'
    end

    scenario "自分以外のユーザーの詳細ページに飛ぼうとすると、root_path（タスク一覧）にリダイレクトされる" do
      visit user_path(another_user)

      expect(page).to have_content 'タスク一覧'
      expect(page).to_not have_content 'another_0000'
    end
  end

  feature "管理機能のテスト" do
    background do
      FactoryBot.create(:task, title: 'momomo', user: another_user)
      FactoryBot.create(:task, title: 'nonono', user: another_user)
      FactoryBot.create(:task, user: user)

      visit root_path

      fill_in 'Email', with: 'admin@example.com'
      fill_in 'Password', with: '123456'
      click_on 'ログインする'

      expect(page).to have_content 'admin_0000'
    end

    scenario "（Admin）ユーザー一覧画面のテスト" do
      visit admin_users_path

      expect(page).to have_content '管理画面・ユーザー一覧'
      expect(page).to have_content 'tester_0000 / タスク数：1'
      expect(page).to have_content 'another_0000 / タスク数：2'
      expect(page).to have_content 'admin_0000 / タスク数：0'
    end

    scenario "（Admin）ユーザー作成のテスト" do
      visit new_admin_user_path

      fill_in '名前', with: 'popono'
      fill_in 'メールアドレス', with: 'popopo@example.com'
      fill_in 'パスワード', with: '123456'
      fill_in 'パスワード（確認）', with: '123456'

      click_on '登録する'
      expect(page).to have_content 'popono'
      expect(page).to have_content '管理者：false'
    end

    scenario "（Admin）ユーザー詳細のテスト" do
      visit admin_user_path(another_user.id)

      expect(page).to have_content '名前：another_0000'
      expect(page).to have_content 'タスク名：momomo'
      expect(page).to have_content 'タスク名：nonono'
    end

    scenario "（Admin）ユーザー編集のテスト" do
      visit edit_admin_user_path(another_user.id)

      fill_in '名前', with: 'second_another'
      check 'Admin'
      fill_in 'パスワード', with: '123456'
      fill_in 'パスワード（確認）', with: '123456'

      click_on '更新する'
      expect(page).to have_content '名前：second_another'
      expect(page).to have_content '管理者：true'

      visit edit_admin_user_path(another_user.id)

      fill_in '名前', with: 'third_another'
      uncheck 'Admin'
      fill_in 'パスワード', with: '123456'
      fill_in 'パスワード（確認）', with: '123456'

      click_on '更新する'
      expect(page).to have_content '名前：third_another'
      expect(page).to have_content '管理者：false'
    end

    scenario "（Admin）ユーザー削除のテスト" do
      visit admin_users_path

      all('p')[1].click_link '削除'
      expect(page).to_not have_content 'another_0000'
    end

    scenario "ログインしていない状態で管理画面に入ろうとしたらエラーを出す" do
      click_link 'ログアウト'

      visit admin_users_path
      expect(page).to have_content 'RuntimeError'
      expect(page).to have_content 'unauthorized_administrator_access'
    end

    scenario "管理者ユーザー以外が管理画面に入ろうとしたらエラーを出す" do
      click_link 'ログアウト'

      fill_in 'Email', with: 'shibata@example.com'
      fill_in 'Password', with: '123456'
      click_on 'ログインする'

      visit admin_users_path
      expect(page).to have_content 'RuntimeError'
      expect(page).to have_content 'unauthorized_administrator_access'
    end

    scenario "一人しかいない管理者ユーザーを削除しようとしたらエラーを出す" do
      visit admin_users_path

      all('p')[2].click_link '削除'
      expect(page).to have_content 'RuntimeError'
      expect(page).to have_content 'application_without_administrator'
    end

    scenario "一人しかいない管理者ユーザーから管理権限を剥がそうとしたらエラーを出す" do
      visit edit_admin_user_path(admin_user.id)

      uncheck 'Admin'
      fill_in 'パスワード', with: '123456'
      fill_in 'パスワード（確認）', with: '123456'

      click_on '更新する'

      expect(page).to have_content 'RuntimeError'
      expect(page).to have_content 'application_without_administrator'
    end

    scenario "管理者ユーザーが二人以上いれば管理者ユーザーを削除してもエラーにならない" do
      FactoryBot.create(:admin_user, email: 'spare_admin@example.com')
      visit admin_users_path

      all('p')[2].click_link '削除'

      expect(page).to_not have_content 'RuntimeError'
    end
  end
end