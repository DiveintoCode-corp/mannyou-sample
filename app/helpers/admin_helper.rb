module AdminHelper
  def choose_admin_new_or_edit
    if action_name == 'new'
      admin_users_path
    elsif action_name == 'edit'
      admin_user_path
    end
  end
end