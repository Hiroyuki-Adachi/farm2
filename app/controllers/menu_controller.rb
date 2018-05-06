class MenuController < ApplicationController
  layout 'menu'
  before_action :permit_manager, except: :index
  before_action :set_system, only: [:edit, :edit_term]

  def index
  end

  def edit
  end

  def edit_term
    @terms = []
    term = Work.minimum(:term)
    term ||= Time.now.year
    while term <= Time.now.year
      @terms << [term, term]
      term += 1
    end
  end

  def update
    if system_params[:term]
      @term = system_params[:term].to_i
      @system = System.find_by(term: @term, organization_id: current_user.organization.id)
      @system ||= System.new(term: @term, organization_id: current_user.organization.id)
      @system.target_from = Date.new(@term, 1, 1)
      @system.target_to   = Date.new(@term, 12, 31)
      @system.start_date  = Date.new(@term, 1, 1)
      @system.end_date    = Date.new(@term, 12, 31)
    else
      @system = System.find_by(term: @term)
      @system.target_from = Date.strptime(system_params['target_from'], "%Y-%m")
      @system.target_to   = Date.strptime(system_params['target_to'], "%Y-%m").end_of_month
    end

    if @system.valid?
      @system.save!
      @organization = current_organization
      @organization.update(term: @term)
      redirect_to(menu_index_path, :notice => '設定を変更しました。')
    elsif system_params[:term]
      render :action => :edit_term
    else
      render :action => :edit
    end
  end

  private

  def system_params
    params.require(:system).permit(:term, :target_from, :target_to)
  end

  def permit_manager
    to_error_path unless current_user.manageable?
  end

  def set_system
    @system = current_system
  end
end
