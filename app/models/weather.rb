class Weather < ActiveYaml::Base
  set_root_path "config/master"
  set_filename "weather"
end