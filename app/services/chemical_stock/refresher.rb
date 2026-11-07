# 薬剤の在庫を再計算する。
# 日報の薬剤使用から在庫(使用)を作り直し、期首在庫を補ったうえで、日付順に在庫量・調整量を積み上げる。
class ChemicalStock::Refresher
  def initialize(organization, chemical_id)
    @organization_id = organization.is_a?(Organization) ? organization.id : organization
    @chemical_id = chemical_id
  end

  def call
    start_date = stocks.minimum(:stock_on) || System.min_date(@organization_id)
    return if start_date.nil?

    from_work(start_date)
    create_begin(start_date)
    accumulate
  end

  private

  def stocks
    ChemicalStock.for_organization(@organization_id).where(chemical_id: @chemical_id)
  end

  def work_stocks
    stocks.where.not(work_chemical_id: nil)
  end

  def accumulate
    tmp_stock = 0
    ChemicalStock.usual(@chemical_id, @organization_id).each do |stock|
      if stock.inventory.nil?
        stock.adjust = (stock.stored || 0) - (stock.using || 0) - (stock.shipping || 0)
        stock.stock = tmp_stock + stock.adjust
      else
        stock.stock = stock.inventory
        stock.adjust = stock.stock - tmp_stock
      end
      stock.save!
      tmp_stock = stock.stock
    end
  end

  def create_begin(start_date)
    System.where(organization_id: @organization_id).where("start_date > ?", start_date).order(:start_date).each do |sys|
      next if stocks.exists?(stock_on: sys.start_date)

      ChemicalStock.create(
        name: "期首在庫",
        stock_on: sys.start_date,
        chemical_id: @chemical_id,
        organization_id: @organization_id
      )
    end
  end

  def from_work(start_date)
    work_stocks.update_all("\"using\" = 0") # rubocop:disable Rails/SkipsModelValidations
    WorkChemical.for_stock(@chemical_id, start_date, @organization_id).each do |work_chemical|
      stock = ChemicalStock.for_organization(@organization_id).find_by(work_chemical_id: work_chemical.id)
      if stock
        stock.update!(work_stock_attributes(work_chemical))
      else
        ChemicalStock.create(
          work_stock_attributes(work_chemical).merge(work_chemical_id: work_chemical.id, chemical_id: @chemical_id)
        )
      end
    end
    work_stocks.where(using: 0).destroy_all
  end

  def work_stock_attributes(work_chemical)
    work = work_chemical.work
    {
      organization_id: @organization_id,
      stock_on: work.worked_at,
      name: "#{work.work_type.name}(#{work.work_kind.name})",
      using: work_chemical.quantity_for_stock
    }
  end
end
