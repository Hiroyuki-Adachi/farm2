module TotalSeedlingsHelper
  def seedling_status(seedling_home, seedling_result_quantities)
    return "未使用" if seedling_result_quantities[seedling_home.id].to_i.zero?
    return "" if seedling_home.quantity <= (seedling_result_quantities[seedling_home.id] || 0)
    return seedling_home.dispose? ? "廃棄" : "不足"
  end

  def seedling_status_danger?(seedling_home, seedling_result_quantities)
    return false if seedling_result_quantities[seedling_home.id].to_i.zero?
    return false if seedling_home.quantity <= (seedling_result_quantities[seedling_home.id] || 0)
    return !seedling_home.dispose?
  end

  def seedling_amount(seedling_home, seedling_result_quantities, seedling_price)
    if seedling_home.quantity > (seedling_result_quantities[seedling_home.id] || 0)
      return (seedling_home.dispose? ? seedling_home.quantity : (seedling_result_quantities[seedling_home.id] || 0)) * seedling_price
    else
      return seedling_home.quantity * seedling_price
    end
  end
end
