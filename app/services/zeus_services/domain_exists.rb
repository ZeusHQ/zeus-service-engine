require 'net/http'

module ZeusServices

    class DomainExists
        include Callable

        attr_accessor :domain

        def initialize(domain)
            self.domain = domain
        end

        def call
            return OpenStruct.new(success?: false, errors: ["Missing domain"]) if self.domain.blank?
            
            resp = Net::HTTP.get(ENV["ZEUS_API_DOMAIN"], "/domains/exists?domain=#{self.domain}")

            OpenStruct.new(success?: true, payload: customer)
        rescue Stripe::StripeError => e
            OpenStruct.new(success?: false, errors: [e])
        end

    end

end