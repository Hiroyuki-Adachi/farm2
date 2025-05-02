class TopicType < ActiveYaml::Base
  include ActiveHash::Enum
  
  set_root_path "config/master"
  set_filename "topic_type"
  
  enum_accessor :code
end
