class BanksController < ApplicationController
  before_action :set_bank, only: [:edit, :update, :destroy]

  # GET /banks
  # GET /banks.json
  def index
    @banks = Bank.all
  end

  # GET /banks/new
  def new
    @bank = Bank.new
  end

  # GET /banks/1/edit
  def edit
  end

  # POST /banks
  # POST /banks.json
  def create
    @bank = Bank.new(bank_params)

    if @bank.save
      redirect_to banks_path
    else
      render :new
    end
  end

  def update
    if @bank.update(bank_params)
      redirect_to banks_path
    else
      render :edit
    end
  end

  # DELETE /banks/1
  # DELETE /banks/1.json
  def destroy
    @bank.destroy
    redirect_to banks_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank
      @bank = Bank.find_by(code: params[:code])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_params
      params.require(:bank).permit(:code, :name, :phonetic)
    end
end
