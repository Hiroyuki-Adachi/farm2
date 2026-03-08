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
      total_cost_type = row[:account]&.total_cost_type
      type_totals[key] ||= {
        total_cost_type_id: total_cost_type_id,
        total_cost_type_name: total_cost_type&.name || "未設定",
        account_flag: total_cost_type&.account,
        debit_total: 0,
        credit_total: 0
      }
      type_totals[key][:debit_total] += row[:amount][0]
      type_totals[key][:credit_total] += row[:amount][1]
    end
    @total_cost_type_rows = type_totals.values.map do |row|
      amount_total = if row[:account_flag]
                       row[:debit_total] - row[:credit_total]
                     else
                       row[:credit_total] - row[:debit_total]
                     end
      row.merge(amount_total: amount_total)
    end.sort_by do |row|
      [
        row[:total_cost_type_id].nil? ? 1 : 0,
        row[:total_cost_type_id] || Float::INFINITY
      ]
    end
  end

  def create
    SorimachiAccount.import(current_term)
    redirect_to sorimachi_accounts_path
  end

  def edit; end

  def update
    @account.attributes = sorimachi_account_params
    if @account.save
      allocate_work_types(@account)
      redirect_to sorimachi_accounts_path
    else
      render action: :edit
    end
  end

  def destroy
    unless @account.new_record?
      clear_related_work_types(@account)
      @account.destroy
    end
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
        :total_cost_type_id
      ])
  end

  def allocate_work_types(account)
    total_cost_type = account.total_cost_type
    return clear_related_work_types(account) if total_cost_type.nil?

    allocator = Sorimachi::WorkTypeAllocationService.new(term: account.term, system: current_system)
    journals_for_account(account).find_each do |journal|
      amount = signed_amount(journal, account.code, total_cost_type.account)
      allocator.allocate!(journal: journal, amount: amount, accounted_on: journal.accounted_on)
      journal.update!(allocation_mode: :auto)
    end
  end

  def clear_related_work_types(account)
    journals = journals_for_account(account)
    SorimachiWorkType.where(sorimachi_journal_id: journals.select(:id)).delete_all
    journals.update_all(allocation_mode: SorimachiJournal.allocation_modes[:auto])
  end

  def journals_for_account(account)
    SorimachiJournal.where(term: account.term)
      .where(code01: account.code)
      .or(SorimachiJournal.where(term: account.term, code12: account.code))
  end

  def signed_amount(journal, account_code, account_flag)
    amount = 0.to_d
    if journal.code01 == account_code
      amount += account_flag ? journal.amount1 : -journal.amount1
    end
    if journal.code12 == account_code
      amount += account_flag ? -journal.amount2 : journal.amount2
    end
    amount
  end
end
