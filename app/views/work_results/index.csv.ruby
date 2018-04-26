require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  cols = {
    WorkResult.human_attribute_name(:home_name)      => ->(w){  w.worker.home.name },
    WorkResult.human_attribute_name(:worker_name)    => ->(w) { w.worker.name },
    WorkResult.human_attribute_name(:worked_at)      => ->(w) { w.work.worked_at },
    WorkResult.human_attribute_name(:work_type_name) => ->(w) { w.work.work_type.genre_name + "(#{w.work.work_type.name})" },
    WorkResult.human_attribute_name(:work_name)      => ->(w) { w.work.work_kind.name + "(#{w.work.name})" },
    WorkResult.human_attribute_name(:hours)          => ->(w) { w.hours },
    WorkResult.human_attribute_name(:price)          => ->(w) { w.work.price },
    WorkResult.human_attribute_name(:amount)         => ->(w) { w.hours * w.work.price }
  }
  csv << cols.keys
  @results.each do |work|
    csv << cols.map { |_k, col| col.call(work) }
  end
end

NKF::nkf('--sjis -Lw', csv_str)
