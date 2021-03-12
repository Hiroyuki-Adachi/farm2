require 'rubyXL'
require 'rubyXL/convenience_methods/cell'
require 'rubyXL/convenience_methods/workbook'

class Calendars::ExcelsController < CalendarsController
  include PermitManager

  def index
    workbook = RubyXL::Parser.parse('app/views/calendars/excels/3month01.xlsx')

    workbook.calc_pr.full_calc_on_load = true
    workbook.calc_pr.calc_completed = true
    workbook.calc_pr.calc_on_save = true
    workbook.calc_pr.force_full_calc = true

    calendar_work_kind = @calendar_work_kinds[0]
    data_sheet = workbook[0]

    title_cell = data_sheet[3][0]
    title_cell.change_contents("#{calendar_work_kind.work_kind.name}")

    data_sheet[5][0].change_contents(@works[0].model.worked_at.year)
    first_month = @works[0].model.worked_at.month
    data_sheet[5][2].change_contents(first_month)

    @works.each do |work|
      work_cell = data_sheet[work.model.worked_at.day * 2 + 4][(work.model.worked_at.month - first_month) * 3 + 2]
      work_cell.change_contents("#{work.exact_work_type_name}(#{work.sum_areas}a)")
      # work_cell.change_font_color(calendar_work_kind.excel_color)
    end

    respond_to do |format|
      format.xlsx do
       send_data workbook.stream.read, filename: "calendar.xlsx".encode(Encoding::Windows_31J)
      end
    end
  ensure
    workbook.stream.close  # streamを閉じる
  end
end
