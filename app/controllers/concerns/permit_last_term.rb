module PermitLastTerm
  extend ActiveSupport::Concern
  
  included do
    before_action :permit_term
  end
  
  private
  
  def permit_term
    to_error_path unless last_term?
  end
end
