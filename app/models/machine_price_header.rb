class MachinePriceHeader < ActiveRecord::Base
  belongs_to :machine
  belongs_to :machine_type
  
  has_many :details, {class_name: :MachinePriceDetail}

  scope :show_type, -> (machine_type, base_date){where("machine_type_id = ? AND validated_at < ?" , machine_type, base_date).order("validated_at DESC").first}
  scope :show_machine, -> (machine, base_date){where("machine_id = ? AND validated_at < ?" , machine, base_date).order("validated_at DESC").first}
  
  def details_form
    results = {}
    work_kinds = machine_id == 0 ? self.machine_type.work_kinds : self.machine_kinds
    Lease.all.each do |lease|
      result = {}
      detail = self.details.where(lease_id: lease.id, work_kind_id: 0)
      if detail.exists?
        result[0] = {adjust_id: detail.adjust_id, price: detail.price}
      else
        result[0] = {adjust_id: 0, price: 0}
      end
      work_kinds.each do |work_kind|
        detail = self.details.where(lease_id: lease.id, work_kind_id: work_kind.id)
        if detail.exists?
          result[work_kind.id] = {adjust_id: detail.adjust_id, price: detail.price}
        else
          result[work_kind.id] = {adjust_id: 0, price: 0}
        end
      end
      
      results[lease.id] = result
    end
    
    return results
  end
  
  def name
    return self.machine_id == 0 ? self.machine_type.name : self.machine.name
  end
end
