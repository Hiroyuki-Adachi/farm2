class MenuController < ApplicationController
  before_action :set_system, only: [:index, :edit, :edit_term, :update]
  
  def index
  end

  def edit
  end

  def edit_term
    @terms = []
    term = Work.minimum(:year)
    term = Time.now.year unless term
    while term <= Time.now.year do
      @terms << [term, term]
      term += 1
    end
  end

  def update
    if system_params[:term]
      @system.term = system_params[:term]
    else
      @system.target_from = Date.new(system_params['target_from(1i)'].to_i, system_params['target_from(2i)'].to_i, 1)
      @system.target_to   = Date.new(system_params['target_to(1i)'].to_i, system_params['target_to(2i)'].to_i, 1).end_of_month
    end

    if @system.valid?
      @system.save!
      redirect_to(root_path, :notice => '設定を変更しました。')
    else
      if system_params[:term]
        render :action => :edit_term
      else
        render :action => :edit
      end
    end
  end
  
  private
  def set_system
    @system = System.first
  end
  
  def system_params
    return params.require(:system).permit(:term, 'target_from(1i)', 'target_from(2i)', 'target_to(1i)', 'target_to(2i)')
  end
end
