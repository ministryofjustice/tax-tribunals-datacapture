Rails.application.config.assets.version = '1.1'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile << %r{fonts/[\w-]+\.(?:eot|svg|ttf|woff2?)$}
Rails.application.config.assets.precompile << %r{images/[\w-]+\.(?:png|svg)$}
Rails.application.config.assets.precompile += %w(
  ie8.css
  apple-touch-icon.png
  apple-touch-icon-180x180.png
  apple-touch-icon-167x167.png
)
