class Chemicals::DesticidesController < ApplicationController
  include PermitManager

  def index
  end

  def create
    Desticide.transaction do
      Desticide.import(params[:import_file])
    end
    redirect_to chemicals_desticides_path
  end
end
