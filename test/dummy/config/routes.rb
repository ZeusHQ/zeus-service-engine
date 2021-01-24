Rails.application.routes.draw do
  mount Zeus::Service::Engine::Engine => "/zeus-service-engine"
end
