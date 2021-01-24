class Zeus::Service::Engine::HomeController < ApplicationController
    def index
        service_name = Rails.application.class.module_parent.name.clone.gsub("Service", "").downcase
        render json: {service: service_name}
    end
end