class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.human_attribute_enum_value(attr_name, value)
    return if value.blank?
    human_attribute_name("#{attr_name}.#{value}")
  end
 
  def human_attribute_enum(attr_name)
    self.class.human_attribute_enum_value(attr_name, self.send("#{attr_name}"))
  end
end
