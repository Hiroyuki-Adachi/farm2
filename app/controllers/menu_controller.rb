class MenuController < ApplicationController
  before_action :set_system
  
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
      @system.target_from = Date.new(@system.term, 1, 1)
      @system.target_to   = Date.new(@system.term, 12, 31)
    else
      @system.target_from = Date.strptime(system_params['target_from'], "%Y-%m")
      @system.target_to   = Date.strptime(system_params['target_to'], "%Y-%m").end_of_month
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
    return params.require(:system).permit(:term, :target_from, :target_to)
  end
end
