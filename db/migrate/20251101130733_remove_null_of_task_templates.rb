class RemoveNullOfTaskTemplates < ActiveRecord::Migration[8.1]
  def change
    change_column_null :task_templates, :monthly_stage, true
    change_column_null :task_templates, :months_before_due, true
    change_column_null :task_templates, :offset, true
  end
end
