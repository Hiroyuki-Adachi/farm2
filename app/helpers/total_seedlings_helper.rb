module TotalSeedlingsHelper
  def seedling_status(seedling_home)
    return "" if seedling_home.quantity <= (@seedling_result_quantities[seedling_home.id] || 0)
    return seedling_home.dispose? ? "廃棄" : "不足"
  end

  def seedling_amount(seedling_home)
    if seedling_home.quantity > (@seedling_result_quantities[seedling_home.id] || 0)
      return (seedling_home.dispose? ? seedling_home.quantity : (@seedling_result_quantities[seedling_home.id] || 0)) * @seedling_price
    else
      return seedling_home.quantity * @seedling_price
    end
  end
end
