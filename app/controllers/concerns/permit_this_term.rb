module PermitThisTerm
  extend ActiveSupport::Concern
  
  included do
    before_action :permit_term
  end
  
  private
  
  def permit_term
    to_error_path unless this_term?
  end
end
