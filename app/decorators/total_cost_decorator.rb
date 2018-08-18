class TotalCostDecorator < Draper::Decorator
  delegate_all

  def kind_name
    if work_chemical_id.present?
      work_chemical.chemical.name
    elsif work.present?
      work.work_kind.name
    elsif expense.present?
      expense.expense_type.name
    elsif depreciation.present?
      depreciation.machine.machine_type.name
    elsif seedling_home.present?
      seedling_home.home_name
    elsif land.present?
      land.manager.name
    end
  end

  def detail_name
    if land.present?
      land.place
    elsif depreciation.present?
      depreciation.machine.alias_name
    else
      occurred_on.strftime('%m-%d')
    end
  end
end
