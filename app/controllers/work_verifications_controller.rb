class WorkVerificationsController < ApplicationController
  include PermitChecker
  before_action :load_works, only: [:index]
  before_action :set_work, only: [:show, :update, :destroy]

  def index
    respond_to_format(:html)
  end

  def update
    WorkVerification.regist(@work, current_user.worker)
    reload
  end

  def destroy
    WorkVerification.where(work_id: @work.id, worker_id: current_user.worker.id).destroy_all
    reload
  end

  def show
    @work = @work.decorate
    @results = WorkResultDecorator.decorate_collection(@work.work_results.includes(:worker) || [])
    @work_lands = WorkLandDecorator.decorate_collection(@work.work_lands.includes(:land) || [])
    respond_to_format(:html, partial: "show")
  end

  private

  def reload
    load_works
    respond_to_format(:html, partial: "list")
  end

  def load_works
    @works = WorkDecorator.decorate_collection(Work.for_verifications(current_user))
  end

  def set_work
    @work = Work.where(fixed_at: nil, term: current_term).find(params[:work_id])
    to_error_path if @work.nil?
  end
end
