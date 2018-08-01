class TotalCostDecorator < Draper::Decorator
  delegate_all

  def kind_name
    if work_chemical_id.present?
      work_chemical.chemical.name
    elsif work.present?
      work.work_kind.name
    elsif expense.present?
      expense.content
    elsif depreciation.present?
      depreciation.machine&.usual_name
    elsif seedling_home.present?
      seedling_home.home_name
    elsif land.present?
      land.manager.name
    end
  end

  def detail_name
    land.present? ? land.place : occurred_on.strftime('%m-%d')
  end
end
