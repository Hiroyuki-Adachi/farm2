class WorkerDecorator < Draper::Decorator
  delegate_all

  def short_name
    model.family_name[0, 2] + "(" + model.first_name[0] + ")"
  end

  def disp_name
    model.name + "(" + model.first_phonetic + ")"
  end

  def permission_name
    model.user ? model.user.permission.name : ""
  end

  def login_name
    model.user ? model.user.login_name : ""
  end
end
