class WorkKindType < ActiveRecord::Base
  belongs_to :work_kind
  belongs_to :work_type
end
