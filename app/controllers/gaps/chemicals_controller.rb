class Gaps::ChemicalsController < GapsController
  def index
    return unless params[:chemical_type_id]

    @chemicals = ChemicalTerm.by_type(current_term, params[:chemical_type_id], current_organization)
    @stocks = {}
    @chemicals.each do |chemical|
      ChemicalStock.refresh(current_organization.id, chemical.id)
      stocks = ChemicalStock.usual(chemical.id, current_organization).where(stock_on: current_system.start_date..current_system.end_date)
      @stocks[chemical.id] = ChemicalStockDecorator.decorate_collection(stocks) unless stocks.empty?
    end
  end
end
