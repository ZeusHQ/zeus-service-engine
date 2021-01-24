class AuthCommands::AuthorizeApiRequest
    include Zeus::Service::Engine::Concerns::Callable

    attr_accessor :headers, :cookies

    def initialize(headers, cookies)
        self.headers = headers
        self.cookies = cookies
    end

    def call
        zeus_key = self.http_zeus_key_header

        if zeus_key.present?
            return self.authenticate_zeus_request(zeus_key)
        else
            public_key = self.http_public_key_header
            secret_key = self.http_secret_key_header

            env = Zeus::Service::Engine::ProjectEnvironment.where(public_key: public_key).first

            if env.present?
                return OpenStruct.new(success?: true, errors: nil, payload: {env: env, public: true}) if private_key.blank?
                return OpenStruct.new(success?: true, errors: nil, payload: {env: env, public: false}) if private_key == env.secret_key
                return OpenStruct.new(success?: false, errors: ["Invalid private key"])
            else
                return OpenStruct.new(success?: false, errors: ["Invalid public key"])
            end
        end

        return OpenStruct.new(success?: false, errors: ["Unable to authorize"])
    end

    protected

    def authenticate_zeus_request(zeus_key)
        if zeus_key.present? && zeus_key == ENV["ZEUS_AUTH_KEY"]
            return OpenStruct.new(success?: true)
        else
            puts(ENV.inspect)
            return OpenStruct.new(success?: false, errors: ["Invalid zeus key"])
        end
    end

    def http_zeus_key_header
        if @headers['HTTP_X_ZEUS_AUTH_KEY'].present?
          return @headers['HTTP_X_ZEUS_AUTH_KEY']
        end
        nil
    end

    def http_public_key_header        
        if @headers["HTTP_X_ZEUS_SERVICE_PUBLIC_KEY"].present?
          return @headers["HTTP_X_ZEUS_SERVICE_PUBLIC_KEY"]
        end
        nil
    end

    def http_secret_key_header
        if @headers["HTTP_X_ZEUS_SERVICE_SECRET_KEY"].present?
          return @headers["HTTP_X_ZEUS_SERVICE_SECRET_KEY"]
        end
        nil
    end
end