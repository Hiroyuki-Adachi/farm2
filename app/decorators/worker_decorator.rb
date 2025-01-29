class WorkerDecorator < Draper::Decorator
  delegate_all

  def short_name
    "#{model.family_name[0, 2]}(#{model.first_name[0]})"
  end

  def home_name
    home_name = model.home.name
    home_name += "(#{model.first_name[0]})" unless model.id == model.home.worker_id
    return home_name
  end

  def disp_name
    "#{model.name}(#{model.first_phonetic})"
  end

  def permission_name
    model&.user&.permission_name || ''
  end

  def login_name
    model&.user&.login_name || ''
  end
end
