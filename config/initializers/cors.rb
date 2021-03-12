# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        origins '*'
        # origins do |source, env|
        #     domain = URI(source.downcase.strip).host
        #     # domain = source.downcase.strip.gsub(/https:\/\//, "")
        #     result = true
           
        #     if Rails.env.production?
        #         result = ["zeusdev.io", "www.zeusdev.io", "admin.zeusdev.io"].include?(domain) || domain.ends_with?("zeusdev.app")
        #         if result == false
        #             client = ZeusSdk::V1::Core.new("")
        #             res = client.check_domain(domain)
        #             result = res.parsed_response["exists"]
        #         end
        #     end

        #     puts("CORS #{source} // #{domain} = #{result}")

        #     result
        # end

        # origins ['localhost:3001', 'localhost:3020'] if Rails.env.development?
  
        resource '*',
            headers: :any,
            expose: "Authorization",
            credentials: true,
            methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
end