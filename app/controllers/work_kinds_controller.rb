class WorkKindsController < ApplicationController
  include PermitChecker
  include ReturnToIndex

  before_action :set_work_kind, only: [:edit, :update, :destroy]
  before_action :set_others, only: [:new, :create, :edit, :update]
  before_action :set_cost_types, only: [:new, :create, :edit, :update]
  keeps_index_return_to path_method: :work_kinds_path

  def index
    @work_kinds = WorkKind.usual.page(params[:page])
  end

  def new
    @work_kind = WorkKind.new(price: current_system.default_price)
  end

  def edit; end

  def create
    @work_kind = WorkKind.new(work_kind_params)
    if save_with_others { @work_kind.save }
      redirect_to work_kinds_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    if save_with_others { @work_kind.update(work_kind_params) }
      redirect_to @return_to
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @work_kind.discard
    redirect_to @return_to, status: :see_other
  end

  private

  def set_work_kind
    @work_kind = WorkKind.find(params[:id])
    @work_kind.term = current_term
    @work_kind.organization_id = current_organization.id
  end

  def work_kind_params
    permitted = params.expect(work_kind:
      [
        :name,
        :display_order,
        :price,
        :land_flag,
        :broccoli_mark,
        :phonetic,
        :cost_type_id,
        :aggregation_flag
      ])
    permitted[:land_flag] = false unless permitted.key?(:land_flag)
    permitted[:aggregation_flag] = false unless permitted.key?(:aggregation_flag)
    permitted.merge(term: current_term, organization_id: current_organization.id)
  end

  def set_others
    @categories = organization_categories.usual
    @machine_types = MachineType.order(:display_order, :id)
    @chemical_types = ChemicalType.order(:display_order, :id)
  end

  # 関連の更新に失敗した場合(他組織のカテゴリ指定など)は作業種別の保存も取り消す
  def save_with_others
    WorkKind.transaction do
      saved = yield
      update_others if saved
      saved
    end
  end

  def update_others
    @work_kind.categories = selected_categories
    @work_kind.machine_types = params[:machine_types] ? MachineType.find(params[:machine_types]) : []
    @work_kind.chemical_types = params[:chemical_types] ? ChemicalType.find(params[:chemical_types]) : []
  end

  def organization_categories
    WorkCategory.for_organization(current_organization)
  end

  # 作業種別は組織共通のため(#1273で対応)、他組織のカテゴリとの対応は残す
  def selected_categories
    selected = params[:work_categories] ? organization_categories.find(params[:work_categories]) : []
    @work_kind.categories.where.not(organization_id: current_organization.id) + selected
  end

  def set_cost_types
    @cost_types = CostType.usual
  end
end
