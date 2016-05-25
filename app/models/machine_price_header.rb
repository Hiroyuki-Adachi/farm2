class MachinePriceHeader < ActiveRecord::Base
  require "ostruct"

  belongs_to :machine
  belongs_to :machine_type
  
  after_save :save_details

  has_many :details, {class_name: :MachinePriceDetail, dependent: :destroy}

  scope :show_type, -> (machine_type, base_date){where("machine_type_id = ? AND validated_at <= ?" , machine_type, base_date).order("validated_at DESC")}
  scope :show_machine, -> (machine, base_date){where("machine_id = ? AND validated_at <= ?" , machine, base_date).order("validated_at DESC")}
  scope :histories, -> (machine_price){where("(machine_id = ? AND machine_id <> 0) OR (machine_type_id = ? AND machine_type_id <> 0)", machine_price.machine_id, machine_price.machine_type_id).order("validated_at ASC")}
  
  def machine?
    return self.machine_id != 0
  end
  
  def machine_type?
    return self.machine_id == 0
  end
  
  def work_kinds
    results = [OpenStruct.new(id: 0, name: "標準")]
    (machine? ? self.machine.machine_type.work_kinds : self.machine_type.work_kinds).each do |work_kind|
      results << OpenStruct.new(id: work_kind.id, name: work_kind.name)
    end
    return results
  end
  
  def details_form
    results = {}
    Lease.all.each do |lease|
      result = {}
      work_kinds.each do |work_kind|
        detail = self.details.where(lease_id: lease.id, work_kind_id: work_kind.id)
        if detail.exists?
          result[work_kind.id] = {adjust_id: detail.first.adjust_id, price: detail.first.price}
        else
          result[work_kind.id] = {adjust_id: 0, price: 0}
        end
      end
      
      results[lease.id] = result
    end
    
    return results
  end
  
  def details_form=(val)
    @details_form = val
  end
  
  def name
    return self.machine_id == 0 ? self.machine_type.name : self.machine.name
  end
  
  def save_details
    @details_form.each do |lease_id, v1|
      v1.each do |work_kind_id, v2|
        detail = MachinePriceDetail.where(machine_price_header_id: self.id, lease_id: lease_id, work_kind_id: work_kind_id)
        if detail.exists?
          if v2[:adjust_id].to_i == Adjust::NONE.id
            detail.first.destroy
          else
            detail.first.update_attributes(adjust_id: v2[:adjust_id], price: v2[:price])
          end
        else
          if v2[:adjust_id].to_i != Adjust::NONE.id
            MachinePriceDetail.create(machine_price_header_id: self.id, lease_id: lease_id, work_kind_id: work_kind_id, adjust_id: v2[:adjust_id], price: v2[:price])
          end
        end
      end
    end
  end
end
