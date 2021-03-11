class Calendars::ExcelsController < ApplicationController
  include PermitManager

  def index
    workbook = RubyXL::Parser.parse('app/views/calendars/excels/3month01.xlsx')

    respond_to do |format|
      format.xlsx do
       send_data workbook.stream.read,
         filename: "calendar.xlsx".encode(Encoding::Windows_31J)
      end
    end
  ensure
    workbook.stream.close  # streamを閉じる
  end
end
