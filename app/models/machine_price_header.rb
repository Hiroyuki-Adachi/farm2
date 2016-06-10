# == Schema Information
#
# Table name: machine_price_headers
#
#  id              :integer          not null, primary key
#  validated_at    :date             not null
#  machine_id      :integer          default(0), not null
#  machine_type_id :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class MachinePriceHeader < ActiveRecord::Base
  require "ostruct"

  belongs_to :machine
  belongs_to :machine_type
  
  after_save :save_details

  has_many :details, {class_name: "MachinePriceDetail", dependent: :destroy}

  scope :show_type, -> (machine_type, base_date){where("machine_type_id = ? AND validated_at <= ?" , machine_type, base_date).order("validated_at DESC")}
  scope :show_machine, -> (machine, base_date){where("machine_id = ? AND validated_at <= ?" , machine, base_date).order("validated_at DESC")}
  scope :histories, -> (machine_price){where("(machine_id = ? AND machine_id <> 0) OR (machine_type_id = ? AND machine_type_id <> 0)", machine_price.machine_id, machine_price.machine_type_id).order("validated_at ASC")}
  
  def machine?
    return machine_id != 0
  end
  
  def machine_type?
    return machine_id == 0
  end
  
  def work_kinds
    results = [OpenStruct.new(id: 0, name: "標準")]
    (machine? ? machine.machine_type.work_kinds : machine_type.work_kinds).each do |work_kind|
      results << OpenStruct.new(id: work_kind.id, name: work_kind.name)
    end
    return results
  end
  
  def details_form
    results = {}
    Lease.all.each do |lease|
      result = {}
      work_kinds.each do |work_kind|
        detail = details.where(lease_id: lease.id, work_kind_id: work_kind.id).first
        if detail
          result[work_kind.id] = {adjust_id: detail.adjust_id, price: detail.price}
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
    return machine_id == 0 ? machine_type.name : machine.usual_name
  end
  
  private
  def save_details
    @details_form.each do |lease_id, v1|
      v1.each do |work_kind_id, v2|
        detail = MachinePriceDetail.where(machine_price_header_id: id, lease_id: lease_id, work_kind_id: work_kind_id).first
        if detail.present?
          if v2[:adjust_id].to_i == Adjust::NONE.id
            detail.destroy
          else
            detail.update_attributes(adjust_id: v2[:adjust_id], price: v2[:price])
          end
        else
          if v2[:adjust_id].to_i != Adjust::NONE.id
            MachinePriceDetail.create(machine_price_header_id: id, lease_id: lease_id, work_kind_id: work_kind_id, adjust_id: v2[:adjust_id], price: v2[:price])
          end
        end
      end
    end
  end
end
