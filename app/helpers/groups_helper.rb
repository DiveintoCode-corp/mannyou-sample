module GroupsHelper
  def participate_or_withdraw(group, user)
    if group.user == user
      link_to t("layout.group.delete"), group, method: :delete, data: { confirm: t("layout.views.confirm_destroy") }
    elsif join = group.joins.find_by(user_id: current_user.id)
      link_to t("layout.group.leave"), join_path(join.id), method: :delete, data: { confirm: t("layout.join.confirm_destroy") }
    else
      link_to t("layout.group.join"), joins_path(group_id: group.id), method: :post
    end
  end
end