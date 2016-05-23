class MachinePriceHeader < ActiveRecord::Base
  belongs_to :machine
  belongs_to :machine_type
  
  has_many :details, {class_name: :MachinePriceDetails}

end
