require 'wareki'

class WorkDecorator < Draper::Decorator
  delegate_all
  decorates_association :creator
  decorates_association :printer

  def self.terms
    terms = []
    term = Work.minimum(:term)
    term ||= Time.zone.now.year
    while term <= Time.zone.now.year
      terms << [term, term]
      term += 1
    end
    return terms
  end

  def worked_at
    model.worked_at.strftime('%Y-%m-%d') + "(#{I18n.t('date.abbr_day_names')[model.worked_at.wday]})"
  end

  def worked_at_long
    model.worked_at.strftime('%Jy年%m月%d日') + "(#{I18n.t('date.abbr_day_names')[model.worked_at.wday]})"
  end

  def worked_at_weekday
    model.worked_at.strftime('%m月%d日') + "(#{I18n.t('date.abbr_day_names')[model.worked_at.wday]})"
  end

  def worked_at_short
    model.worked_at&.strftime('%m-%d')
  end

  def fixed_at
    model.fixed_at&.strftime('%Jy年%m月')
  end

  def name
    if model.name.present?
      model.work_kind.other_flag ? model.name : model.work_kind.name + "(#{model.name})"
    else
      model.work_kind.name
    end
  end

  def work_time
    "#{start_at}～#{end_at}"
  end

  def work_type_name
    "#{model.work_type&.genre_name}(#{model.work_type&.name})"
  end

  def start_at
    model.start_at.strftime("%H:%M")
  end

  def end_at
    model.end_at.strftime("%H:%M")
  end

  def chemicals
    result = model.work_chemicals.map do |work_chemical|
      "#{work_chemical.chemical.name}(#{work_chemical.chemical.chemical_type.name}):#{work_chemical.quantity}"
    end
    return result.to_sentence
  end

  def genre_name
    work_type_name
  end

  def select_work_type(work_type)
    if work_type.id == model.work_type_id
      return "●#{work_type.name}"
    elsif model.work_types.ids.include?(work_type.id)
      return "◯#{work_type.name}"
    end
    return h.raw("&nbsp;") + work_type.name
  end

  def self.get_terms(term)
    terms = Work.get_terms(term).map { |t| [t.strftime('%Jy年%m月'), t.strftime('%Y-%m-%d')] }
    return terms
  end

  def sum_hours
    format("%.1f", model.sum_hours)
  end

  def sum_workers_amount
    h.number_to_currency(model.sum_workers_amount, precision: 0, unit: "")
  end

  def sum_machines_amount
    h.number_to_currency(model.sum_machines_amount, precision: 0, unit: "")
  end

  def tr_style
    model.fixed_at ? "background-color: lightGray;" : ""
  end

  def creator_short_name
    model.creator ? creator.short_name : ""
  end

  def created_at
    model.created_at ? model.created_at.to_date.strftime('%Je')[0] + model.created_at.to_date.strftime('%Jg-%m-%d') : nil
  end

  def printer_short_name
    model.printer ? printer.short_name : ""
  end

  def printed_at
    model.printed_at ? model.printed_at.to_date.strftime('%Je')[0] + model.printed_at.to_date.strftime('%Jg-%m-%d') : nil
  end

  def checker_short_names
    model.checkers.map { |checker| checker.decorate.short_name}.to_sentence
  end

  def exists_workers
    model.work_results.none? ? "" : "作業"
  end

  def exists_lands
    model.work_lands.none? ? "" : "土地"
  end

  def exists_machines
    model.machine_results.none? ? "" : "機械"
  end

  def exists_chemicals
    model.work_chemicals.none? ? "" : "薬品"
  end

  def machine_names
    model.machine_results.map(&:machine).flatten.uniq.map(&:type_name).to_sentence
  end

  def gap_worker_names
    model.workers.map { |worker| worker.broccoli_mark.presence || worker.name}.sort.to_sentence
  end

  def gap_land_places
    model.lands.map { |land| land.broccoli_mark.presence || land.place}.sort.to_sentence
  end

  def gap_work_kind_name
    model.work_kind.broccoli_mark.presence || model.work_kind.name
  end

  def exact_work_type_name
    model.exact_work_types.map(&:name).to_sentence
  end

  def machine_numbers
    results = model.machine_numbers.map do |key, value|
      "#{key}-#{value.sort.join(',')}"
    end
    return results.join('、')
  end

  def machine_type_names
    model.machine_types.pluck(:name).join('、')
  end

  def worker_names
    model.workers.map(&:name).join('、') 
  end

  def worker_members
    model.workers.one? ? model.workers[0].name : "#{model.workers.count}名"
  end

  def training_name
    model.training && model.training.content.present? ? model.training.content : model.name
  end

  def training_studied_on
    model.training&.studied_on ? model.training.studied_on.strftime('%Y-%m-%d') + "(#{I18n.t('date.abbr_day_names')[model.training.studied_on.wday]})" : ""
  end

  def type_and_kind_name
    return "#{model.work_type&.name}:#{self.name}"
  end
end
