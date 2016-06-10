# == Schema Information
#
# Table name: works
#
#  id           :integer          not null, primary key
#  term         :integer          not null
#  worked_at    :date             not null
#  weather_id   :integer
#  work_type_id :integer
#  name         :string(40)       not null
#  remarks      :text
#  start_at     :datetime         not null
#  end_at       :datetime         not null
#  fixed_at     :date
#  work_kind_id :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Work < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions

  require 'ostruct'
  
  before_create :set_term

  validates :worked_at, presence: true
  validates :weather,   presence: true
  validates :name, length: {maximum: 40}, :if =>  Proc.new{|x| x.name.present?}

  belongs_to :work_type, -> {with_deleted}
  belongs_to :work_kind, -> {with_deleted}
  belongs_to :weather

  has_many :work_lands,     ->{order('work_lands.display_order')},  {dependent: :destroy}
  has_many :work_results,   ->{order('work_results.display_order')}, {dependent: :destroy}
  has_many :work_chemicals, ->{order('work_chemicals.id')}, {dependent: :destroy}

  has_many :workers,    {through: :work_results}
  has_many :lands,      {through: :work_lands}
  has_many :chemicals,  {through: :work_chemicals}
  
  has_many :machine_results, {through: :work_results}

  scope :no_fixed, ->(term){where(term: term, fixed_at: nil).order(worked_at: :ASC, id: :ASC)}
  scope :months, ->(term){select()}

  def set_term
    self.term = Organization.first.term
  end

  def sum_hours
    return self.work_results.sum(:hours)
  end
  
  def sum_areas
    return self.lands.sum(:area)
  end
  
  def price
    return work_kind.term_price(self.term)
  end

  def sum_machine_amounts
    return machine_results.to_a.uniq{|result| result.machine_id}.inject(0){|sum, result| sum += result.amount} || 0
  end

  def self.get_terms(term)
    params = []
    result = Work.where(term: term).maximum(:fixed_at)
    result = result ? result.to_date : Date.new(term, 1, 1)
    result = result.next.end_of_month.to_date
    while(result < Time.now.to_date) do
      params << result
      result = result.next_month.end_of_month.to_date
    end
    return params
  end

  def self.clear_fix(fixed_at)
    Work.where(fixed_at: fixed_at).update_all("fixed_at = null")
  end

  def chemicals_format
    result = []
    self.work_chemicals.each do |work_chemical|
      result << work_chemical.chemical.name + "(" + work_chemical.chemical.chemical_type.name + "):" + work_chemical.quantity.to_s
    end
    return result.join(", ")
  end
  
  def regist_results(params)
    workers = []
    params.each do |param|
      param = OpenStruct.new(param)
      workers << param.worker_id.to_i
      work_result = work_results.where(worker_id: param.worker_id).first
      if work_result
        work_result.update(display_order: param.display_order, hours: param.hours) if work_result.display_order != param.display_order.to_i or work_result.hours != param.hours.to_f 
      else
        WorkResult.create(work_id: id, worker_id: param.worker_id, display_order: param.display_order, hours: param.hours)
      end
    end
    
    work_results.where.not(worker_id: workers).each {|work_result| work_result.destroy}    
  end
  
  def regist_lands(params)
    lands = []
    params.each do |param|
      param = OpenStruct.new(param)
      lands << param.land_id
      work_land = work_lands.where(land_id: param.land_id).first
      if work_land
        work_land.update(display_order: param.display_order) if work_land.display_order != param.display_order.to_i 
      else
        WorkLand.create(work_id: self.id, land_id: param.land_id, display_order: param.display_order)
      end
    end

    work_lands.where.not(land_id: lands).each {|land| land.destroy}
  end
  
  def regist_machines(params)
    params.each do |machine_id, work_result|
      work_result.each do |work_result_id, hour|
        hour = hour.to_f
        machine_result = MachineResult.where(work_result_id: work_result_id, machine_id: machine_id).first
        if machine_result
          if hour > 0
            machine_result.update(hours: hour) if machine_result.hours != hour 
          else
            machine_result.destroy
          end
        else
          MachineResult.create(work_result_id: work_result_id, machine_id: machine_id, hours: hour) if hour > 0
        end
      end
    end
  end 

  def regist_chemicals(params)
    params.each do |chemical_id, quantity|
      chemical_id = chemical_id.to_i
      quantity = quantity.to_i
      work_chemical = work_chemicals.where(chemical_id: chemical_id).first
      if work_chemical
        if quantity > 0
          work_chemical.update(quantity: quantity) unless work_chemical.quantity == quantity
        else
          work_chemical.destroy
        end
      else
        WorkChemical.create(work_id: id, chemical_id: chemical_id, quantity: quantity) if quantity > 0
      end
    end
  end
end
