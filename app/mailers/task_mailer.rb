class TaskMailer < ApplicationMailer
  def task_mail(user, tasks)
    @user = user
    @tasks = tasks

    mail to: @user.email, subject: "【mannyou-dev】タスクの締め切りが迫っています！大丈夫でしょうか？"
  end
end
