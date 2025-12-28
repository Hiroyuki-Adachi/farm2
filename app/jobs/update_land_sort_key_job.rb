class UpdateLandSortKeyJob < ApplicationJob
  queue_as :default

  def perform
    # rubocop:disable Style/SymbolProc
    Land.target_place_sort_key.find_each { |land| land.init_place_sort_key }
    # rubocop:enable Style/SymbolProc
  end
end
