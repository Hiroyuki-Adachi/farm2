Rails.application.routes.draw do
  if Rails.env.production?
    scope '/farm2' do
      draw :all_routes
    end
  else
    draw :all_routes
  end
end
