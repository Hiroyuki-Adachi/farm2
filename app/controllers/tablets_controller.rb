class TabletsController < ApplicationController
  layout 'tablet'
  skip_before_action :restrict_remote_ip

  def index
    @sections = Section.with_users.usual
    @section_id = params[:section_id] || @sections.first&.id
  end
end
