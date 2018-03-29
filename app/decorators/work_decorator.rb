class WorkDecorator < Draper::Decorator
  delegate_all

  WDAY = ["日", "月", "火", "水", "木", "金", "土"]

  def self.months(term)
    cache_key = "months#{term}"
    months = []
    if Rails.cache.exist?(cache_key)
      months = Rails.cache.read(cache_key)
    else
      months << ["全て", ""]
      Work.select("date_trunc('month', worked_at) AS worked_month").where(term: term).order("date_trunc('month', worked_at)").uniq.each {|w|
        worked_month = DateTime.parse(w.worked_month.to_s)
        months << [worked_month.strftime("%Y年%m月"), worked_month.strftime("%Y-%m-01")]
      }
      Rails.cache.write(cache_key, months, expires_in: 1.hour)
    end
    return months
  end

  def worked_at
    model.worked_at.strftime('%Y-%m-%d') + "(#{WDAY[model.worked_at.wday]})"
  end

  def fixed_at
    model.fixed_at.strftime('%Y年 %m月') if model.fixed_at
  end

  def name
    model.name.present? ? (model.work_kind.other_flag ? model.name : model.work_kind.name + "(#{model.name})") : model.work_kind.name
  end

  def work_time
    start_at + '～' + end_at
  end

  def work_type_name
    return model.work_type.genre_name + "(#{model.work_type.name})"
  end

  def start_at
    model.start_at.strftime("%H:%M")
  end

  def end_at
    model.end_at.strftime("%H:%M")
  end

  def chemicals
    result = []
    model.work_chemicals.each do |work_chemical|
      result << work_chemical.chemical.name + "(" + work_chemical.chemical.chemical_type.name + "):" + work_chemical.quantity.to_s
    end
    return result.join(", ")
  end

  def genre_name
    model.work_type.genre_name + "(#{model.work_type.name})"
  end

  def select_work_type(work_type)
    h.raw((work_type.id == model.work_type_id ? "●" : "&nbsp;") + work_type.name)
  end

  def weather_name
    model.weather ? model.weather.name : ""
  end

  def self.get_terms(term)
    terms = []
    Work.get_terms(term).each { |t| terms << [t.strftime('%Y年 %m月'), t.strftime('%Y-%m-%d')] }
    return terms
  end

  def sum_hours
    "%.1f"%[model.sum_hours]
  end

  def sum_workers_amount
    h.number_to_currency(model.sum_workers_amount, {precision: 0, unit: ""})
  end

  def sum_machines_amount
    h.number_to_currency(model.sum_machines_amount, {precision: 0, unit: ""})
  end

  def tr_style
    model.fixed_at ? "background-color: lightGray;" : ""
  end

  def creator_short_name
    model.creator ? model.creator.family_name + "(" + model.creator.first_name[0] + ")" : ""
  end

  def created_at
    model.created_at.strftime('%Y-%m-%d')
  end

  def checker_short_names
    results = []
    model.checkers.each do |checker|
      results << checker.family_name + "(" + checker.first_name[0] + ")"
    end
    results.join(", ")
  end

  def exists_workers
    model.work_results.count == 0 ? "" : "作業"
  end

  def exists_lands
    model.work_lands.count == 0 ? "" : "土地"
  end

  def exists_machines
    model.machine_results.count == 0 ? "" : "機械"
  end

  def exists_chemicals
    model.work_chemicals.count == 0 ? "" : "薬品"
  end
end
