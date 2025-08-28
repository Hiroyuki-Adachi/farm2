Rails.application.routes.draw do
  if Rails.env.production?
    scope '/farm2' do
      mount ActionCable.server => "/farm2/cable"
      draw :all_routes
    end
  else
    mount ActionCable.server => "/cable"
    draw :all_routes
  end
end
