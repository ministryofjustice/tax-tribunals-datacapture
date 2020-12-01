Rails.application.config.assets.version = '1.1'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w[*.png *.ico]
Rails.application.config.assets.precompile += %w[.svg .eot .woff .ttf .woff2 .woff]
Rails.application.config.assets.precompile += %w(
  apple-touch-icon.png
  apple-touch-icon-180x180.png
  apple-touch-icon-167x167.png
)
