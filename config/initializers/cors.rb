# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors
Rails.application.config.hosts << "localhost"


Rails.application.config.middleware
  .insert_before(0,
    Rack::Cors,
    debug: (not Rails.env.production?),
    logger: (-> { Rails.logger })) do
  allow do
    origins 'api.os.uk'

    resource '*',
      headers: :any,
      methods: [:get, :post, :delete, :put, :patch, :options, :head],
      max_age: 0,
      credentials: true
  end
end
