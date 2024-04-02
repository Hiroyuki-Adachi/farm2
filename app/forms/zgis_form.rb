require 'rubyXL'
require 'rubyXL/convenience_methods/cell'

class ZgisForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  def export(term); end
end
