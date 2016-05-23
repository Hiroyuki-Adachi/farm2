class MachinePriceGroup < ActiveRecord::Base
    belongs_to :machine
    belongs_to :machine_type

    has_many :values, ->{includes(:work_kinds).order("machine_price_values.lease_id, work_kinds.display_order NULLS FIRST")} {class_name: :MachinePriceValue, dependent: :destroy}
    has_one  :value,  {class_name: :MachinePriceValue}
end
