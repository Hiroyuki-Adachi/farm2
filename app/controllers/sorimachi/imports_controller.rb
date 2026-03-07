class Sorimachi::ImportsController < ApplicationController
  include PermitManager

  def index
    prepare_journal_rows
  end

  def auto_allocate
    prepare_total_cost_type_context
    account_map = selected_account_map
    journals = filtered_journals(account_map.keys)
    allocated_sums = SorimachiWorkType.where(sorimachi_journal_id: journals.select(:id)).group(:sorimachi_journal_id).sum(:amount)
    allocator = Sorimachi::WorkTypeAllocationService.new(term: current_term, system: current_system)

    journals.find_each do |journal|
      target_amount = journal_target_amount(journal, account_map)
      allocated_amount = allocated_sums[journal.id] || 0
      next unless target_amount.to_d.round(0) != allocated_amount.to_d.round(0)
      allocator.allocate!(journal: journal, amount: target_amount, accounted_on: journal.accounted_on)
    end
    redirect_to sorimachi_imports_path(total_cost_type_id: @selected_total_cost_type_id)
  end

  def create
    SorimachiJournal.transaction do
      SorimachiJournal.import(current_term, params[:import_file])
      SorimachiJournal.update_cost_flag(current_term)
      SorimachiJournal.refresh(current_term)
    end
    redirect_to sorimachi_imports_path
  rescue => e
    @error = e.message
    prepare_journal_rows
    render action: :index, status: :internal_server_error
  end

  private

  def prepare_journal_rows
    prepare_total_cost_type_context
    account_map = selected_account_map
    account_codes = account_map.keys
    @journals = filtered_journals(account_codes).page(params[:page])
    allocated_sums = SorimachiWorkType.where(sorimachi_journal_id: @journals.map(&:id)).group(:sorimachi_journal_id).sum(:amount)
    journal_targets = {}

    @journal_rows = []
    @journals.each do |journal|
      journal_targets[journal.id] ||= journal_target_amount(journal, account_map)
      if account_map[journal.code01]
        @journal_rows << journal_row(journal, account_map[journal.code01], signed_amount(journal.amount1, "debit"), "debit")
      end
      if account_map[journal.code12]
        @journal_rows << journal_row(journal, account_map[journal.code12], signed_amount(journal.amount2, "credit"), "credit")
      end
    end
    @journal_rows.each do |row|
      allocated_amount = allocated_sums[row[:journal_id]] || 0
      row[:unallocated] = journal_targets[row[:journal_id]].to_d.round(0) != allocated_amount.to_d.round(0)
    end
  end

  def prepare_total_cost_type_context
    @total_cost_types = TotalCostType.accountable.sort_by(&:code)
    @selected_total_cost_type_id = selected_total_cost_type_id
    @selected_total_cost_type = @total_cost_types.find {|t| t.id == @selected_total_cost_type_id}
  end

  def selected_account_map
    SorimachiAccount.where(term: current_term, total_cost_type_id: @selected_total_cost_type_id).index_by(&:code)
  end

  def selected_total_cost_type_id
    return nil if @total_cost_types.blank?
    selected_id = params[:total_cost_type_id].to_i
    type_ids = @total_cost_types.map(&:id)
    type_ids.include?(selected_id) ? selected_id : @total_cost_types.first.id
  end

  def filtered_journals(account_codes)
    return SorimachiJournal.none if account_codes.blank?
    SorimachiJournal.where(term: current_term)
      .where(code01: account_codes)
      .or(SorimachiJournal.where(term: current_term, code12: account_codes))
      .order(:line, :detail)
  end

  def journal_row(journal, account, amount, side)
    {
      id: "#{journal.id}_#{side}",
      journal_id: journal.id,
      line: journal.line,
      detail: journal.detail,
      accounted_on: journal.accounted_on,
      account_name: account.name,
      amount: amount,
      remark1: journal.remark1,
      remark3: journal.remark3,
      unallocated: false
    }
  end

  def journal_target_amount(journal, account_map)
    amount = 0.to_d
    amount += signed_amount(journal.amount1, "debit") if account_map[journal.code01]
    amount += signed_amount(journal.amount2, "credit") if account_map[journal.code12]
    amount
  end

  def signed_amount(amount, side)
    return amount if @selected_total_cost_type&.account.nil?
    if @selected_total_cost_type.account
      side == "debit" ? amount : -amount
    else
      side == "debit" ? -amount : amount
    end
  end
end
