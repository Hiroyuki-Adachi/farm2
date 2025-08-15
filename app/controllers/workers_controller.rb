class WorkersController < ApplicationController
  include PermitChecker
  before_action :set_worker, only: [:edit, :update, :destroy]
  before_action :set_homes, only: [:new, :create, :edit, :update]
  before_action :set_genders, only: [:new, :create, :edit, :update]
  before_action :set_positions, only: [:new, :create, :edit, :update]

  def index
    @workers = WorkerDecorator.decorate_collection(Worker.usual.page(params[:page]))
  end

  def new
    @worker = Worker.new
  end

  def edit; end

  def create
    @worker = Worker.new(worker_params)
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
      redirect_to workers_path
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @worker.discard
    redirect_to workers_path, status: :see_other
  end

  private

  def set_worker
    @worker = Worker.find(params[:id])
  end

  def set_homes
    @homes = Home.usual
  end

  def set_genders
    @genders = Gender.all
  end

  def set_positions
    @positions = Position.all
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
        :broccoli_mark
      ])
  end
end
