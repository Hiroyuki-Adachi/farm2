class MachineKind < ActiveRecord::Base
  belongs_to :machine_type
  belongs_to :work_kind
end
