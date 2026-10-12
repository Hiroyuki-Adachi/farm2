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
        register_chemical(chemical_id, chemical_group_no, quantity)
      end
    end
  end

  private

  def register_chemical(chemical_id, chemical_group_no, quantity)
    work_chemical = @work.work_chemicals.find_by(chemical_id: chemical_id, chemical_group_no: chemical_group_no)
    if unused_quantity?(quantity[:quantity])
      work_chemical&.destroy!
    else
      work_chemical ||= @work.work_chemicals.build(chemical_id: chemical_id, chemical_group_no: chemical_group_no)
      work_chemical.update!(quantity_params(quantity))
    end
  end

  def unused_quantity?(value)
    value.blank? || value.to_s.match?(/\A0+(?:\.0+)?\z/)
  end

  def quantity_params(quantity)
    permitted = quantity.permit(:quantity, :dilution_id, :magnification, :remarks)
    permitted[:magnification] = nil if permitted[:dilution_id].to_i == Dilution::NONE.id
    permitted
  end
end
