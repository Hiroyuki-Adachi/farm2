module StatisticsHelper
  ALL_MONTHS = (1..12)

  COLORS = [
    'rgba(99, 200, 132, 1.0)',
    'rgba(99, 132, 200, 1.0)',
    'rgba(200, 200, 132, 1.0)',
    'rgba(132, 132, 132, 1.0)',
    'rgba(99, 200, 200, 1.0)',
    'rgba(200, 132, 132, 1.0)',
    'rgba(200, 132, 200, 1.0)'
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

  def tab2_datasets(total_all, genres, total_genre)
    results = []
    genres.each_with_index do |genre, i|
      results << {
        label: genre.combined_name,
        data: total_all.map {|t| total_genre[[genre.id, t[0]]].to_f },
        backgroundColor: genre.graph_color.presence || COLORS[i],
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

  def tab4_datasets(current_results, previous_results, average_results)
    results = []
    results << {
      label: "過去平均",
      data: ALL_MONTHS.map { |month| average_results[month - 1].to_f },
      backgroundColor: COLORS[1],
      fill: false
    }
    results << {
      label: "前年度",
      data: ALL_MONTHS.map { |month| previous_results[month - 1].to_f },
      backgroundColor: 'rgba(192, 192, 192, 1.0)',
      fill: false
    }
    results << {
      label: "今年度",
      data: ALL_MONTHS.map { |month| current_results[month - 1].to_f },
      backgroundColor: COLORS[0],
      fill: false
    }
    return results
  end
end
