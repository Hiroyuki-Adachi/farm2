# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += ['controllers/calendar.js']
Rails.application.config.assets.precompile += ['controllers/chemicals-stocks.js']
Rails.application.config.assets.precompile += ['controllers/edit-chemicals.js']
Rails.application.config.assets.precompile += ['controllers/edit-dryings.js']
Rails.application.config.assets.precompile += ['controllers/fixes.js']
Rails.application.config.assets.precompile += ['controllers/homes.js']
Rails.application.config.assets.precompile += ['controllers/jquery.selection.js']
Rails.application.config.assets.precompile += ['controllers/land-fees.js']
Rails.application.config.assets.precompile += ['controllers/lands-cards.js']
Rails.application.config.assets.precompile += ['controllers/lands-groups.js']
Rails.application.config.assets.precompile += ['controllers/lands-maps.js']
Rails.application.config.assets.precompile += ['controllers/lands.js']
Rails.application.config.assets.precompile += ['controllers/loading.js']
Rails.application.config.assets.precompile += ['controllers/organizations.js']
Rails.application.config.assets.precompile += ['controllers/pc-common.js']
Rails.application.config.assets.precompile += ['controllers/plan-lands.js']
Rails.application.config.assets.precompile += ['controllers/schedule-workers.js']
Rails.application.config.assets.precompile += ['controllers/sorimachi.js']
Rails.application.config.assets.precompile += ['controllers/work-index.js']
Rails.application.config.assets.precompile += ['controllers/work-lands.js']
Rails.application.config.assets.precompile += ['controllers/work-map.js']
Rails.application.config.assets.precompile += ['controllers/work-show.js']
Rails.application.config.assets.precompile += ['controllers/work-verifications.js']
Rails.application.config.assets.precompile += ['controllers/work-workers.js']
