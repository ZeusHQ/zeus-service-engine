# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        origins do |source, env|
            if Rails.env.production?
                return true if ["www.zeusdev.co", "admin.zeusdev.co"].include?(source)
                return true if source.ends_with?("zeusdev.app")
            end

            if Rails.env.development?
                return true
            end

            ZeusServices::DomainExists.call(source).success?
        end

        origins 'localhost:3001' if Rails.env.development?
  
        resource '*',
            headers: :any,
            expose: "Authorization",
            credentials: true,
            methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
end