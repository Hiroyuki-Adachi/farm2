class ContractsController < ApplicationController
  include PermitManager

  def index
    @works = Work.usual(current_term).exists_lands.where(work_type_id: current_organization.contract_work_type_id)
  end
end
