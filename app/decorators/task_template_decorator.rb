class TaskTemplateDecorator < Draper::Decorator
  include PriorityPresenter

  delegate_all

  def priority_name
    super(object.priority)
  end

  def kind_name
    I18n.t("activerecord.enums.task_template.kinds.#{object.kind}")
  end

  def office_role_name
    I18n.t("activerecord.enums.task_template.office_roles.#{object.office_role}")
  end

  def row_class
    return "table-danger"  if object.discarded?
    return "table-warning" unless object.active?
    ""
  end
end
