class BroccoliController < ApplicationController
  before_action :check_work
  before_action :set_broccoli
  before_action :permit_not_visitor

  def edit
  end

  def update
    @broccoli.attributes = broccoli_params
    if @broccoli.valid?
      @broccoli.save!
      @broccoli.regist_harvests(params[:harvests])
      redirect_to(broccoli_work_path)
    else
      render action: :edit
    end
  end

  def destroy
    @broccoli.destroy
    redirect_to(broccoli_work_path)
  end

  private

  def check_work
    @work = Work.find(params[:work_id])
    redirect_to work_path(@work) unless broccoli?(@work)
  end

  def set_broccoli
    @broccoli = @work.broccoli || WorkBroccoli.new(work_id: @work.id, shipped_on: @work.worked_at)
    @broccoli = @broccoli.decorate
    @boxes = BroccoliBox.usual
    @sizes = BroccoliSize.usual
    @ranks = BroccoliRank.usual
  end

  def broccoli_params
    params.require(:work_broccoli).permit(:broccoli_box_id, :shipped_on, :rest, :harvest, :work_id)
  end

  def broccoli_work_path
    work_path(id: params[:work_id], page: params[:page], month: params[:month])
  end

  def permit_not_visitor
    to_error_path if current_user.visitor?
  end
end
