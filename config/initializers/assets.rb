# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.paths += %w( manifest_homeowner.css )
Rails.application.config.assets.paths += %w( manifest_admin.css )

Rails.application.config.assets.precompile += %w( manifest_homeowner.css )
Rails.application.config.assets.precompile += %w( manifest_admin.css )
Rails.application.config.assets.precompile += %w( Spaciable_full.svg )
Rails.application.config.assets.precompile += %w( expiry_banner.png )
Rails.application.config.assets.precompile += %w( default_banner.png )
Rails.application.config.assets.precompile += ["styleguide.html"]

# WYSIWYG Editor
Rails.application.config.assets.paths += %w( ckeditor/config.js )
Rails.application.config.assets.precompile += %w( ckeditor/* )

# Choose JS library
Rails.application.config.assets.precompile += %w( chosen.min.css )
