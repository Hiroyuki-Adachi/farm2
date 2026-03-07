class Sorimachi::ImportsController < ApplicationController
  include PermitManager

  def index
    prepare_journal_rows
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
    @total_cost_types = TotalCostType.accountable.sort_by(&:code)
    @selected_total_cost_type_id = selected_total_cost_type_id

    account_scope = SorimachiAccount.where(term: current_term, total_cost_type_id: @selected_total_cost_type_id)
    account_map = account_scope.index_by(&:code)
    account_codes = account_map.keys
    @journals = filtered_journals(account_codes).page(params[:page])

    @journal_rows = []
    @journals.each do |journal|
      if account_map[journal.code01]
        @journal_rows << journal_row(journal, account_map[journal.code01], journal.amount1, "debit")
      end
      if account_map[journal.code12]
        @journal_rows << journal_row(journal, account_map[journal.code12], journal.amount2, "credit")
      end
    end
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
      line: journal.line,
      detail: journal.detail,
      accounted_on: journal.accounted_on,
      account_name: account.name,
      amount: amount,
      remark1: journal.remark1,
      remark3: journal.remark3
    }
  end
end
