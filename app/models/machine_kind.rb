class MachineKind < ActiveRecord::Base
  belongs_to :machine
  belongs_to :work_kind
end
