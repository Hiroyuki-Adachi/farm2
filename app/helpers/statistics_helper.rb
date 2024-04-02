module StatisticsHelper
  COLORS = [
    'rgba(99, 200, 132, 1.0)',
    'rgba(99, 132, 200, 1.0)',
    'rgba(200, 200, 132, 1.0)',
    'rgba(132, 132, 132, 1.0)',
    'rgba(99, 200, 200, 1.0)',
    'rgba(200, 132, 132, 1.0)'
  ].freeze

  def default_color
    return COLORS[0]
  end

  def labels(total_all)
    return total_all.pluck(0)
  end

  def tab1_data(total_all)
    return total_all.map {|t| t[1].to_f}
  end

  def tab2_datasets(total_all, categories, total_genre)
    results = []
    categories.each_with_index do |category, i|
      results << {
        label: category.name,
        data: total_all.map {|t| total_genre[[category.genre, t[0]]].to_f },
        backgroundColor: COLORS[i],
        fill: false
      }
    end
    return results
  end

  def tab3_datasets(total_all, total_age)
    results = []
    t("statistics.age").each_with_index do |age, i|
      results << {
        label: age,
        data: total_all.map {|t| total_age[[t[0], i]].to_f },
        backgroundColor: COLORS[i],
        fill: false
      }
    end
    return results
  end
end
