# == Schema Information
#
# Table name: lands
#
#  id            :integer          not null, primary key
#  place         :string(15)       not null
#  owner_id      :integer
#  manager_id    :integer
#  area          :decimal(5, 2)    not null
#  display_order :integer
#  target_flag   :boolean          default(TRUE), not null
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#

class Land < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :owner, ->{with_deleted}, {class_name: :Home, foreign_key: :owner_id}
  belongs_to :manager, ->{with_deleted}, {class_name: :Home, foreign_key: :manager_id}

  has_one :owner_holder, ->{with_deleted}, {through: :owner, source: :holder}
  has_one :manager_holder, ->{with_deleted}, {through: :manager, source: :holder}

  has_many :work_lands
  has_many :works, {through: :work_lands}

  has_many :land_uses
  has_many :work_types,  {through: :land_uses}

  scope :usual, -> {where(target_flag: true).order("place, display_order")}
  scope :list, -> {includes(:owner, :owner_holder).order("place, lands.display_order, lands.id")}

  validates :place, presence: true
  validates :area, presence: true
  validates :display_order, presence: true

  validates :area, numericality: true, :if => Proc.new{|x| x.area.present?}
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}

  def owner_name
    return self.owner.member_flag ? self.owner_holder.name : self.owner.name
  end

  def manager_name
    return self.manager.member_flag ? self.manager_holder.name : self.manager.name
  end
  
  def self.autocomplete(place)
    results = []
    Land.where("target_flag = ? AND (place like ? OR area = ?)", true, "%#{place}%", place.to_f).order(:place, :display_order).limit(15).each do |land|
      results << {label: land.place + "(#{land.area})", value: land.id, details: {place: land.place, id: land.id, owner: land.owner.name, area: land.area}}
    end
    return results.to_json
  end
end
