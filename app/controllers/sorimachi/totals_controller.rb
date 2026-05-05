class Sorimachi::TotalsController < ApplicationController
  include PermitManager

  def index
    total_cost_types = TotalCostType.accountable.sort_by(&:code)
    selected_id = params[:total_cost_type_id].to_i
    @selected_total_cost_type_id = total_cost_types.map(&:id).include?(selected_id) ? selected_id : total_cost_types.first&.id
    @selected_total_cost_type = total_cost_types.find { |type| type.id == @selected_total_cost_type_id }

    @work_types = WorkType
      .by_term(current_term)
      .where(cost_flag: true, deleted_at: nil)
      .usual_order

    @accounts = SorimachiAccount.where(term: current_term, total_cost_type_id: @selected_total_cost_type_id).order(:code)
    @account_totals = build_account_totals(@accounts.map(&:code))
    @journal_totals = build_journal_totals(@accounts.map(&:code))

    respond_to do |format|
      format.html { render layout: false }
      format.csv { render content_type: "text/csv; charset=cp943" }
    end
  end

  private

  def build_account_totals(account_codes)
    return {} if account_codes.blank?

    journals = SorimachiJournal.where(term: current_term)
      .where(code01: account_codes)
      .or(SorimachiJournal.where(term: current_term, code12: account_codes))
      .select(:id, :code01, :code12)
      .to_a
    return {} if journals.blank?

    allocation_sums = SorimachiWorkType
      .where(sorimachi_journal_id: journals.map(&:id), work_type_id: @work_types.map(&:id))
      .group(:sorimachi_journal_id, :work_type_id)
      .sum(:amount)
    allocations_by_journal = Hash.new { |hash, key| hash[key] = [] }
    allocation_sums.each do |(journal_id, work_type_id), amount|
      allocations_by_journal[journal_id] << [work_type_id, amount]
    end

    totals = Hash.new { |hash, key| hash[key] = Hash.new(0) }
    journals.each do |journal|
      target_codes = []
      target_codes << journal.code01 if account_codes.include?(journal.code01)
      target_codes << journal.code12 if account_codes.include?(journal.code12)
      next if target_codes.blank?

      allocations_by_journal[journal.id].each do |work_type_id, amount|
        target_codes.each do |code|
          totals[code][work_type_id] += amount
        end
      end
    end
    totals
  end

  def build_journal_totals(account_codes)
    return {} if account_codes.blank?

    journals = SorimachiJournal.where(term: current_term)
      .where(code01: account_codes)
      .or(SorimachiJournal.where(term: current_term, code12: account_codes))
      .select(:code01, :code12, :amount1, :amount2)

    totals = Hash.new(0.to_d)
    journals.each do |journal|
      if account_codes.include?(journal.code01)
        totals[journal.code01] += signed_amount(journal.amount1, "debit")
      end
      if account_codes.include?(journal.code12)
        totals[journal.code12] += signed_amount(journal.amount2, "credit")
      end
    end
    totals
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
