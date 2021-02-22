module Zeus::Service::Engine
    class JsonWebToken
        class << self
            def encode(env, payload, exp = 6.months.from_now)
                payload[:exp] = exp.to_i
                JWT.encode(payload, env.secret_key)
            end
    
            def decode(token)
                body = JWT.decode(token, env.secret_key)[0]
                HashWithIndifferentAccess.new body
            rescue
                nil
            end
        end
    end
end