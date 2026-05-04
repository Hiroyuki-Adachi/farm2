class Work::ChemicalsRegistrar
  def initialize(work, params)
    @work = work
    @params = params
  end

  def call
    return if @params.blank?

    @params.each do |chemical_id, chemicals|
      next if chemicals.blank?

      chemical_id = chemical_id.to_i
      chemicals.each do |chemical_group_no, quantity|
        chemical_group_no = chemical_group_no.to_i
        work_chemical = @work.work_chemicals.find_by(chemical_id: chemical_id, chemical_group_no: chemical_group_no)
        if work_chemical
          if quantity[:quantity].to_f.positive?
            work_chemical.update(quantity_params(quantity, {}))
          else
            work_chemical.destroy
          end
        else
          add_params = {work_id: @work.id, chemical_id: chemical_id, chemical_group_no: chemical_group_no}
          WorkChemical.create(quantity_params(quantity, add_params)) if quantity[:quantity].to_f.positive?
        end
      end
    end
  end

  private

  def quantity_params(quantity, add_params)
    quantity.permit(:quantity, :dilution_id, :magnification, :remarks).merge(add_params)
  end
end
