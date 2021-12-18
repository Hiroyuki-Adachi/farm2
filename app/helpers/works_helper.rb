module WorksHelper
  def updatable_work(user, work)
    (user.checkable? || work.created_by == user.worker.id) && work.term == user.term
  end

  def chemical_per_area(areas, chemical_quantity, chemical)
    area_quantity = areas.zero? ? 0 : (chemical_quantity / areas * 10)
    area_quantity *= chemical.base_quantity
    if (area_quantity > 1000000)
      return sprintf("%.2f", area_quantity / 1000000) + chemical.base_unit.mega_name
    end
    if (area_quantity > 1000)
      return sprintf("%.2f", area_quantity / 1000) + chemical.base_unit.kilo_name
    end
    return sprintf("%.2f", area_quantity) + chemical.base_unit.name
  end

  def chemical_dilution(work_chemical)
    case work_chemical.dilution
    when Dilution::L then work_chemical.dilution_amount.to_s(:delimited, delimiter: ',') + "&#8467;"
    when Dilution::MAG then work_chemical.magnification.to_s(:delimited, delimiter: ',') + "倍"
    end
  end
end
