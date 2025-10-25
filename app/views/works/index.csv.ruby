require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  cols = {
    Work.human_attribute_name(:worked_at) => ->(w) {w.worked_at},
    Work.human_attribute_name(:start_at) => ->(w) {w.start_at.strftime("%H:%M")},
    Work.human_attribute_name(:end_at) => ->(w) {w.end_at.strftime("%H:%M")},
    Work.human_attribute_name(:category_name) => ->(w) {w.work_type&.category_name},
    Work.human_attribute_name(:type_name) => ->(w) {w.work_type&.name},
    Work.human_attribute_name(:kind_name) => ->(w) {"#{w.work_kind&.name}#{'(' + w.name + ')' if w.name.present?}"},
    Work.human_attribute_name(:workers_count) => ->(w) {@count_workers[w.id] || 0},
    Work.human_attribute_name(:sum_hours) => ->(w) {@sum_hours[w.id] || 0}
  }
  csv << cols.keys
  @works.each do |work|
    csv << cols.map{|_k, col| col.call(work)}
  end
end

NKF.nkf('--sjis -Lw', csv_str)
