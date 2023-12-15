class ZgisController < ApplicationController
  include PermitManager
  def new
    @zgis = ZgisForm.new
  end

  def create
    target = current_system.start_date
    land_costs = LandCost.usual(Land.regionable.expiry(target), target).includes(land: :owner).includes(:work_type)
    excel_data = ZgisExcelService.call(land_costs)

    respond_to do |format|
      format.xlsx do
       send_data excel_data, filename: "zgis.xlsx".encode(Encoding::Windows_31J)
      end
    end
  end
end
