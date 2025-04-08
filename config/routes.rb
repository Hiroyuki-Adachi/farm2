Rails.application.routes.draw do
  scope Rails.application.config.relative_url_root || '/' do
    draw :all_routes
  end
end
