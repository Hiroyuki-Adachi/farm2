class WorkersController < ApplicationController
  include PermitChecker
  include ReturnToIndex

  before_action :set_worker, only: [:edit, :update, :destroy]
  before_action :set_homes, only: [:new, :create, :edit, :update]
  keeps_index_return_to path_method: :workers_path

  def index
    @workers = WorkerDecorator.decorate_collection(Worker.for_organization(current_organization).usual.page(params[:page]))
  end

  def new
    @worker = Worker.new
  end

  def edit; end

  def create
    @worker = Worker.new(worker_params.merge(organization_id: current_organization.id))
    if params[:holder]
      @worker.home.holder = @worker
      @worker.home.save!
    end
    if @worker.save
      redirect_to workers_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    if params[:holder]
      @worker.home.holder = @worker
      @worker.home.save!
    end
    if @worker.update(worker_params)
      redirect_to @return_to
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @worker.discard
    redirect_to @return_to, status: :see_other
  end

  private

  def set_worker
    @worker = Worker.for_organization(current_organization).find_by(id: params[:id])
    to_error_path unless @worker
  end

  def set_homes
    @homes = Home.for_organization(current_organization).usual
  end

  def worker_params
    params.expect(worker:
      [
        :family_phonetic,
        :family_name,
        :first_phonetic,
        :first_name,
        :home_id,
        :mobile,
        :display_order,
        :gender_id,
        :birthday,
        :position_id,
        :broccoli_mark,
        :office_role
      ])
  end
end
