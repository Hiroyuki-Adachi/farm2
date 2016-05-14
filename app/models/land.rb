class Land < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :owner, {class_name: :Home, foreign_key: :home_id}

  has_many :work_lands
  has_many :works, {through: :work_lands}

  has_many :land_uses
  has_many :work_types,  {through: :land_uses}

  scope :auto_complete, -> (place) {where("place like ? or area = ?", "%#{place}%", place.to_f)}
  scope :organization, -> {where(target_flag: true).order("place, display_order")}

  validates :place, presence: true
  validates :area, presence: true
  validates :display_order, presence: true

  validates :area, numericality: true, :if => Proc.new{|x| x.area.present?}
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}

  def area_format
    return sprintf("%.1f", self.area)
  end

  def owner_name
    return self.owner.member? ? self.owner.holder.name : self.owner.name
  end
end
