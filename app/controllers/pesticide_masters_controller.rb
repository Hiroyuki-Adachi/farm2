class PesticideMastersController < ApplicationController
  include PermitChecker

  before_action :set_pesticide_master, only: [:show]

  def index
    @pesticide_masters = PesticideMaster.order(:registration_number).page(params[:page])
  end

  def show; end

  def create
    import_file = params[:import_file]
    if import_file.blank?
      redirect_to pesticide_masters_path, alert: "インポートするZIPまたはCSVファイルを選択してください。"
      return
    end

    stats = PesticideMaster.import_uploaded_file!(import_file)
    redirect_to pesticide_masters_path,
                notice: "統合農薬マスタを取り込みました。#{stats[:imported]}件 (作成#{stats[:created]}件 / 更新#{stats[:updated]}件)"
  rescue => e
    @error = e.message
    @pesticide_masters = PesticideMaster.order(:registration_number).page(params[:page])
    render :index, status: :unprocessable_content
  end

  private

  def set_pesticide_master
    @pesticide_master = PesticideMaster.find(params[:id])
  end
end
