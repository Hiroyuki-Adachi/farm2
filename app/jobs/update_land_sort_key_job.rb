class UpdateLandSortKeyJob < ApplicationJob
  queue_as :default

  def perform
    Land.target_place_sort_key.find_each do |land|
      land.init_place_sort_key
      land.save!
    end
  end
end
