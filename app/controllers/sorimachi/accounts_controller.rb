class Sorimachi::AccountsController < ApplicationController
  include PermitManager
  before_action :set_sorimachi_account, only: [:edit, :update, :destroy]

  def index
    journals = SorimachiJournal.accounts(current_term)
    accounts = SorimachiAccount.where(term: current_term).index_by(&:code)
    @journal_rows = journals.map do |code, amount|
      account = accounts[code]
      total_cost_type_id = account&.total_cost_type_id.to_i
      {
        code: code,
        amount: amount,
        account: account,
        has_total_cost_type: total_cost_type_id.positive?,
        total_cost_type_id: total_cost_type_id
      }
    end
    @journal_rows.sort_by! do |row|
      [
        row[:has_total_cost_type] ? 0 : 1,
        row[:has_total_cost_type] ? row[:total_cost_type_id] : Float::INFINITY,
        row[:code]
      ]
    end

    type_totals = {}
    @journal_rows.each do |row|
      total_cost_type_id = row[:has_total_cost_type] ? row[:total_cost_type_id] : nil
      key = total_cost_type_id || -1
      type_totals[key] ||= {
        total_cost_type_id: total_cost_type_id,
        total_cost_type_name: row[:account]&.total_cost_type&.name || "未設定",
        debit_total: 0,
        credit_total: 0
      }
      type_totals[key][:debit_total] += row[:amount][0]
      type_totals[key][:credit_total] += row[:amount][1]
    end
    @total_cost_type_rows = type_totals.values.sort_by do |row|
      [
        row[:total_cost_type_id].nil? ? 1 : 0,
        row[:total_cost_type_id] || Float::INFINITY
      ]
    end
  end

  def new
    SorimachiAccount.transaction do
      SorimachiJournal.update_cost_flag(current_term)
      SorimachiJournal.refresh(current_term)
    end
    redirect_to sorimachi_imports_path
  end

  def create
    SorimachiAccount.import(current_term)
    redirect_to sorimachi_accounts_path
  end

  def edit; end

  def update
    @account.attributes = sorimachi_account_params
    if @account.save
      redirect_to sorimachi_accounts_path
    else
      render action: :edit
    end
  end

  def destroy
    @account.destroy unless @account.new_record?
    redirect_to sorimachi_accounts_path
  end

  private

  def set_sorimachi_account
    @account = SorimachiAccount.find_by(term: current_term, code: params[:code])
    @account = SorimachiAccount.new(term: current_term, code: params[:code]) unless @account
  end

  def sorimachi_account_params
    params.expect(sorimachi_account:
      [
        :term,
        :code,
        :name,
        :cost_flag,
        :auto_code,
        :auto_work_type_id,
        :total_cost_type_id
      ])
  end
end
