Rails.application.routes.draw do
  scope ENV.fetch('RAILS_RELATIVE_URL_ROOT', '/') do
    draw :all_routes
  end
end
