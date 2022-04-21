require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick
  plugin :avatarmagick

  secret "ac4cbbaddd9a73a0e865ddfbcfc99547f01fec9d3237b9f3f71d958dc199c3d9"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
