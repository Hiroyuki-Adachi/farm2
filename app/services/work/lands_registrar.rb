class Work::LandsRegistrar
  def initialize(work, params)
    @work = work
    @params = params
  end

  def call
    lands = []
    @params.each do |param|
      land_id = param[:land_id]
      lands << land_id
      display_order = param[:display_order].to_i

      work_land = @work.work_lands.find_by(land_id: land_id)
      if work_land
        work_land.update(display_order: display_order) if work_land.display_order != display_order
      else
        WorkLand.create(work_id: @work.id, land_id: land_id, display_order: display_order)
      end
    end

    @work.work_lands.where.not(land_id: lands).destroy_all

    Work::WorkTypesRegistrar.new(@work).call
  end
end
