Rails.configuration.assets.precompile += %w[serviceworker.js manifest.json]
Rails.application.config.assets.precompile += %w( modulos/alumnos.js)
Rails.application.config.assets.precompile += %w( modulos/tutores.js)
