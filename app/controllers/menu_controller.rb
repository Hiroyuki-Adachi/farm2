class MenuController < ApplicationController
  layout 'menu'

  def index
  end

  def edit
  end

  def edit_term
    @terms = []
    term = Work.minimum(:term)
    term = Time.now.year unless term
    while term <= Time.now.year
      @terms << [term, term]
      term += 1
    end
  end

  def update
    if system_params[:term]
      @term = system_params[:term].to_i
      @system = System.find_by(term: @term)
      @system = System.new(term: @term) unless @system
      @system.target_from = Date.new(@term, 1, 1)
      @system.target_to   = Date.new(@term, 12, 31)
    else
      @system = System.where(term: @term).first
      @system.target_from = Date.strptime(system_params['target_from'], "%Y-%m")
      @system.target_to   = Date.strptime(system_params['target_to'], "%Y-%m").end_of_month
    end

    if @system.valid?
      @system.save!
      @organization = Organization.first
      @organization.update(term: @term)
      session[:organization] = @organization.attributes
      Rails.cache.clear
      Rails.cache.write(term_cache_key, @system.attributes, expires_in: 1.hour)
      redirect_to(root_path, :notice => '設定を変更しました。')
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
end
