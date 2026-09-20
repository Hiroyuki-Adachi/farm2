require 'factory_bot'

FactoryBot.definition_file_paths = [Rails.root.join('test/factories').to_s]
FactoryBot.find_definitions
