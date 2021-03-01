class AuthCommands::AuthorizeApiRequest
    include Zeus::Service::Engine::Concerns::Callable

    attr_accessor :headers, :cookies

    def initialize(headers, cookies)
        self.headers = headers
        self.cookies = cookies
    end

    def authorized?
        true
    end

    def call
        zeus_key = self.http_zeus_key_header

        if zeus_key.present?
            return self.authenticate_zeus_request(zeus_key)
        else
            public_key = self.http_public_key_header
            secret_key = self.http_secret_key_header

            env = Zeus::Service::Engine::ProjectEnvironment.where(public_key: public_key).first
            
            return OpenStruct.new(success?: false, errors: ["Invalid public key"]) if env.blank? 
            return OpenStruct.new(success?: true, errors: nil, payload: {env: env, permissions: PERMISSION_PRIVATE}) if secret_key == env.secret_key 
            return OpenStruct.new(success?: true, errors: nil, payload: {env: env, permissions: PERMISSION_PUBLIC})
        end
    end

    protected

    def authenticate_zeus_request(zeus_key)
        if zeus_key.present? && zeus_key == ENV[HTTP_ZEUS_AUTH_KEY]
            if self.http_zeus_env_id_header.present?
                env = Zeus::Service::Engine::ProjectEnvironment.find(self.http_zeus_env_id_header)
                return OpenStruct.new(success?: true, payload: {env: env, permissions: PERMISSION_ZEUS})
            else
                return OpenStruct.new(success?: true, payload: {env: nil, permissions: PERMISSION_ZEUS})
            end
        else
            return OpenStruct.new(success?: false, errors: ["Invalid zeus key"])
        end
    end

    def http_zeus_env_id_header
        if @headers[HTTP_X_ZEUS_ENVIRONMENT_ID].present?
            return @headers[HTTP_X_ZEUS_ENVIRONMENT_ID]
        end
        nil
    end

    def http_zeus_key_header
        if @headers[HTTP_X_ZEUS_AUTH_KEY].present?
          return @headers[HTTP_X_ZEUS_AUTH_KEY]
        end
        nil
    end

    def http_public_key_header        
        if @headers[HTTP_X_ZEUS_SERVICE_PUBLIC_KEY].present?
          return @headers[HTTP_X_ZEUS_SERVICE_PUBLIC_KEY]
        end
        nil
    end

    def http_secret_key_header
        if @headers[HTTP_X_ZEUS_SERVICE_SECRET_KEY].present?
          return @headers[HTTP_X_ZEUS_SERVICE_SECRET_KEY]
        end
        nil
    end
end