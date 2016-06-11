class BankBranchesController < ApplicationController
  before_action :set_branch, only: [:edit, :update, :destroy]
  before_action :set_bank

  def index
    @branches = BankBranch.where(bank_code: params[:bank_code])
  end

  # GET /banks/new
  def new
    @branch = BankBranch.new(bank_code: params[:bank_code])
  end

  # GET /banks/1/edit
  def edit
  end

  # POST /banks
  # POST /banks.json
  def create
    @branch = BankBranch.new(branch_params)

    if @branch.save
      redirect_to bank_branches_path(bank_code: params[:bank_code])
    else
      render :new
    end
  end

  def update
    if @branch.update(branch_params)
      redirect_to bank_branches_path(bank_code: params[:bank_code])
    else
      render :edit
    end
  end

  # DELETE /banks/1
  # DELETE /banks/1.json
  def destroy
    @branch.destroy
    redirect_to bank_branches_path(bank_code: params[:bank_code])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @branch = BankBranch.find_by(bank_code: params[:bank_code], code: params[:code])
    end

    def set_bank
      @bank = Bank.find_by(code: params[:bank_code])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def branch_params
      params.require(:bank_branch).permit(:code, :name, :phonetic, :zip_code, :address1, :address2, :telephone, :fax).merge(bank_code: params[:bank_code])
    end
end
