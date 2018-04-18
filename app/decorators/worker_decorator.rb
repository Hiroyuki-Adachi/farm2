class WorkerDecorator < Draper::Decorator
  delegate_all

  def short_name
    model.family_name[0, 2] + "(" + model.first_name[0] + ")"
  end

  def disp_name
    model.name + "(" + model.first_phonetic + ")"
  end
end
