class Sorimachi::ImportsController < ApplicationController
  include PermitManager

  def index
    prepare_journal_rows
  end

  def auto_allocate
    prepare_total_cost_type_context
    account_map = selected_account_map
    journals = filtered_journals(account_map.keys).where(allocation_mode: SorimachiJournal.allocation_modes[:auto])
    allocated_sums = SorimachiWorkType.where(sorimachi_journal_id: journals.select(:id)).group(:sorimachi_journal_id).sum(:amount)
    allocator = Sorimachi::WorkTypeAllocationService.new(term: current_term, system: current_system)

    journals.find_each do |journal|
      target_amount = journal_target_amount(journal, account_map)
      allocated_amount = allocated_sums[journal.id] || 0
      next unless target_amount.to_d.round(0) != allocated_amount.to_d.round(0)
      allocator.allocate!(journal: journal, amount: target_amount, accounted_on: journal.accounted_on)
      journal.update!(allocation_mode: :auto)
    end
    redirect_to sorimachi_imports_path(total_cost_type_id: @selected_total_cost_type_id)
  end

  def update_allocation
    prepare_total_cost_type_context
    prepare_work_types
    journal = SorimachiJournal.find_by(id: params[:journal_id], term: current_term)
    return head :not_found unless journal

    row = build_row_for_journal(
      journal: journal,
      side: params[:side],
      account_map: selected_account_map,
      selected_work_type_ids: selected_work_type_ids
    )
    return head :unprocessable_entity if row.nil?

    render partial: "journal_row", locals: {row: row, work_types: @work_types}
  end

  def update_detail
    prepare_total_cost_type_context
    prepare_work_types
    journal = SorimachiJournal.find_by(id: params[:journal_id], term: current_term)
    return head :not_found unless journal

    amounts = normalized_detail_amounts
    SorimachiWorkType.transaction do
      SorimachiWorkType.refresh(journal.id, {amounts: amounts})
      journal.update!(allocation_mode: :manual)
    end

    row = build_row_for_journal(
      journal: journal,
      side: params[:side],
      account_map: selected_account_map
    )
    return head :unprocessable_entity if row.nil?

    render partial: "journal_row", locals: {row: row, work_types: @work_types}
  end

  def reallocate_row
    prepare_total_cost_type_context
    prepare_work_types
    journal = SorimachiJournal.find_by(id: params[:journal_id], term: current_term)
    return head :not_found unless journal

    account_map = selected_account_map
    target_amount = journal_target_amount(journal, account_map)
    allocator = Sorimachi::WorkTypeAllocationService.new(term: current_term, system: current_system)
    allocator.allocate!(journal: journal, amount: target_amount, accounted_on: journal.accounted_on)
    journal.update!(allocation_mode: :auto)

    row = build_row_for_journal(
      journal: journal,
      side: params[:side],
      account_map: account_map
    )
    return head :unprocessable_entity if row.nil?

    render partial: "journal_row", locals: {row: row, work_types: @work_types}
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
    prepare_work_types
    account_map = selected_account_map
    @journals = filtered_journals(account_map.keys)

    @journal_rows = []
    @journals.each do |journal|
      debit_row = build_row_for_journal(journal: journal, side: "debit", account_map: account_map)
      credit_row = build_row_for_journal(journal: journal, side: "credit", account_map: account_map)
      @journal_rows << debit_row if debit_row
      @journal_rows << credit_row if credit_row
    end
  end

  def build_row_for_journal(journal:, side:, account_map:, selected_work_type_ids: nil)
    account_code = side == "debit" ? journal.code01 : journal.code12
    account = account_map[account_code]
    return nil unless account

    target_amount = journal_target_amount(journal, account_map)
    if selected_work_type_ids
      allocator = Sorimachi::WorkTypeAllocationService.new(term: current_term, system: current_system)
      allocator.allocate!(
        journal: journal,
        amount: target_amount,
        accounted_on: journal.accounted_on,
        work_type_ids: normalize_selected_work_type_ids(selected_work_type_ids)
      )
      journal.update!(allocation_mode: :select)
    end

    allocation_sums = SorimachiWorkType.where(sorimachi_journal_id: journal.id, work_type_id: @work_types.map(&:id)).group(:work_type_id).sum(:amount)
    allocation_items = @work_types.map do |work_type|
      {work_type_id: work_type.id, name: work_type.name, amount: allocation_sums[work_type.id] || 0}
    end
    allocation_map = allocation_items.index_by {|item| item[:work_type_id] }
    allocated_amount = allocation_sums.values.sum
    amount = side == "debit" ? signed_amount(journal.amount1, "debit") : signed_amount(journal.amount2, "credit")

    {
      id: "#{journal.id}_#{side}",
      journal_id: journal.id,
      side: side,
      line: journal.line,
      detail: journal.detail,
      accounted_on: journal.accounted_on,
      account_name: account.name,
      amount: amount,
      remark1: journal.remark1,
      remark3: journal.remark3,
      target_amount: target_amount,
      allocated_amount: allocated_amount,
      unallocated: target_amount.to_d.round(0) != allocated_amount.to_d.round(0),
      manual_mode: journal.allocation_mode_manual?,
      allocations: allocation_items,
      allocation_map: allocation_map
    }
  end

  def prepare_total_cost_type_context
    @total_cost_types = TotalCostType.accountable.sort_by(&:code)
    @selected_total_cost_type_id = selected_total_cost_type_id
    @selected_total_cost_type = @total_cost_types.find {|type| type.id == @selected_total_cost_type_id}
  end

  def prepare_work_types
    scope = WorkType
      .by_term(current_term)
      .reorder(nil)
      .where(cost_flag: true, deleted_at: nil)
      .select(:id)
      .distinct

    @work_types = WorkType.where(id: scope).usual_order
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

  def selected_work_type_ids
    return nil unless ActiveModel::Type::Boolean.new.cast(params[:work_type_ids_present])
    Array(params[:work_type_ids]).map(&:to_i)
  end

  def normalize_selected_work_type_ids(ids)
    valid_ids = @work_types.map(&:id)
    selected_ids = ids & valid_ids
    non_land_ids = @work_types.select {|work_type| !work_type.land_flag }.map(&:id)
    non_land_selected = selected_ids & non_land_ids
    return [non_land_selected.min] if non_land_selected.present?
    selected_ids
  end

  def normalized_detail_amounts
    raw = params[:amounts].is_a?(ActionController::Parameters) ? params[:amounts].to_unsafe_h : (params[:amounts] || {})
    valid_ids = @work_types.map(&:id).map(&:to_s)
    raw.each_with_object({}) do |(work_type_id, value), hash|
      next unless valid_ids.include?(work_type_id.to_s)
      hash[work_type_id.to_s] = value.to_d.round(0).to_i
    end
  end
end
