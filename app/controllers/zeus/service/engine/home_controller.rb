class Zeus::Service::Engine::HomeController < ApplicationController
    skip_before_action :authorize_api_request!

    def index
        service_name = Rails.application.class.module_parent.name.clone.gsub("Service", "").downcase
        render json: {service: service_name}
    end
end