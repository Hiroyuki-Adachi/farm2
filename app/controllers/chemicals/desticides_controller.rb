require 'csv'
class Chemicals::DesticidesController < ApplicationController
  include PermitManager

  def index
  end

  def create
    import_file = params[:import_file]
    first_row = CSV.new(import_file.tempfile, headers: false).first
    column_count = first_row.size
  
    ActiveRecord::Base.transaction do
      if column_count == Desticide::COLUMN_COUNT
        Desticide.import(import_file)
      elsif column_count == DesticideDetail::COLUMN_COUNT
        DesticideDetail.import(import_file)
      end
    end
    redirect_to chemicals_desticides_path
  end
end
