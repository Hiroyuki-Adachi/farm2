class Land < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :owner, {class_name: :Home, foreign_key: :owner_id}
  belongs_to :manager, {class_name: :Home, foreign_key: :manager_id}

  has_many :work_lands
  has_many :works, {through: :work_lands}

  has_many :land_uses
  has_many :work_types,  {through: :land_uses}

  scope :auto_complete, -> (place) {where("place like ? or area = ?", "%#{place}%", place.to_f)}
  scope :usual, -> {where(target_flag: true).order("place, display_order")}
  scope :list, -> {includes(:owner).order("place, lands.display_order, lands.id")}

  validates :place, presence: true
  validates :area, presence: true
  validates :display_order, presence: true

  validates :area, numericality: true, :if => Proc.new{|x| x.area.present?}
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}

  def area_format
    return sprintf("%.2f", self.area)
  end

  def owner_name
    return self.owner.member_flag ? self.owner.holder.name : self.owner.name
  end

  def manager_name
    return self.manager.member_flag ? self.manager.holder.name : self.manager.name
  end
end
