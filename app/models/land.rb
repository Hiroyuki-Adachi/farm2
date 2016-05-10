class Land < ActiveRecord::Base
  acts_as_paranoid

  TARGET_ORGANIZATION = 1 #組合管理
  TARGET_PERSON       = 0 #個人管理

  belongs_to :owner, {:class_name => 'Home', :foreign_key => 'home_id'}

  has_many :work_lands
  has_many :works, :through => :work_lands

  has_many :land_uses
  has_many :work_types,  :through  => :land_uses

  named_scope :auto_complete, lambda {|place| {
        :conditions => ["target_flag = ? and (place like ? or area = ?)",
          TARGET_ORGANIZATION, "%#{place}%", place.to_f],
        :order => 'place, display_order', :limit => 15}
      }

  named_scope :organization, {
      :conditions => ["target_flag = ?", TARGET_ORGANIZATION],
      :order => 'place, display_order'
    }

  validates_presence_of :place
  validates_presence_of :area
  validates_presence_of :display_order

  validates_numericality_of :area,  :if => Proc.new{|x| x.area.present?}
  validates_numericality_of :display_order, :only_integer =>true, :if => Proc.new{|x| x.display_order.present?}

  def area_format
    return sprintf("%.1f", self.area)
  end

  def owner_name
    return self.owner.member? ? self.owner.holder.name : self.owner.name
  end
end
