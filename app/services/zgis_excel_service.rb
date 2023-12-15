require 'rubyXL'
require 'rubyXL/convenience_methods/cell'
require 'rubyXL/convenience_methods/workbook'
require 'rubyXL/convenience_methods/worksheet'

class ZgisExcelService
  include Workbook
  START_ROW = 2

  def self.call(land_costs)
    return new.call(land_costs)
  end
    
  def call(land_costs)
    workbook = RubyXL::Parser.parse('app/views/zgis/excels/zgis.xlsx')
    setup_workbook(workbook)

    fill_lands(workbook[0], land_costs)

    return workbook.stream.read
  end

  private

  def fill_lands(sheet, land_costs)
    land_costs.each_with_index do |land_cost, index|
      row = START_ROW + index
      cell = sheet.add_cell(row, 0)
      cell.change_contents(zgis_polygon(land_cost.land))
      sheet.add_cell(row, 1, land_cost.land_id)
      sheet.add_cell(row, 2, land_cost.land.place)
      sheet.add_cell(row, 3, land_cost.land.area.to_f)
      sheet.add_cell(row, 4, land_cost.work_type.name)
    end
  end
  
  def zgis_polygon(land)
    return "" if land.region.empty?
    polygons = land.region_values.map { |region| "#{region[1]} #{region[0]}" }
    return "Polygon((#{polygons.join(",")}))"
  end
end
