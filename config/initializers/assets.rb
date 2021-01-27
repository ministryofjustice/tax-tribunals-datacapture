Rails.application.config.assets.version = '1.1'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w[*.png *.ico]
Rails.application.config.assets.precompile += %w[.svg .eot .woff .ttf .woff2 .woff]
Rails.application.config.assets.precompile += %w(
  apple-touch-icon.png
  apple-touch-icon-180x180.png
  apple-touch-icon-167x167.png
)
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/all.css']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/all.js']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/all-ie8.css']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/images/favicon.ico']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/images/govuk-apple-touch-icon-152x152.png']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/images/govuk-apple-touch-icon-167x167.png']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/images/govuk-apple-touch-icon-180x180.png']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/images/govuk-apple-touch-icon.png']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/images/govuk-crest-2x.png']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/images/govuk-crest.png']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/images/govuk-logotype-crown.png']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/images/govuk-mask-icon.svg']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/images/govuk-opengraph-image.png']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/fonts/bold-affa96571d-v2.woff']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/fonts/bold-b542beb274-v2.woff2']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/fonts/light-94a07e06a1-v2.woff2']
Rails.application.config.assets.precompile += ['govuk-frontend/govuk/assets/fonts/light-f591b13f7d-v2.woff']


