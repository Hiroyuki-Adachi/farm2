module WorksHelper
  def updatable_work(user, work)
    (user.checkable? || work.created_by == user.worker.id) && work.term == user.term
  end

  def chemical_per_area(areas, chemical_quantity, chemical)
    area_quantity = areas.zero? ? 0 : (chemical_quantity / areas * 10)
    area_quantity *= chemical.base_quantity
    return format("%.2f", chemical.unit_quantity(area_quantity)) + chemical.unit_name(area_quantity)
  end

  def chemical_dilution(work_chemicals, chemical_id)
    dilution = work_chemicals.where(chemical_id: chemical_id).order(:chemical_group_no).first.dilution
    counter = work_chemicals.where(chemical_id: chemical_id).count
    amount = 0
    unit = ""
    work_chemicals.where(chemical_id: chemical_id).find_each do |work_chemical|
      case dilution
      when Dilution::L
        unit = "ℓ"
        amount += work_chemical.dilution_amount
      when Dilution::MAG 
        unit = "倍"
        amount += work_chemical.magnification
      end
    end
    return amount.zero? || counter.zero? ? "" : (amount / counter).round(0).to_fs(:delimited, delimiter: ',') + unit
  end
end
