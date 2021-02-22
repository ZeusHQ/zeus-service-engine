Zeus::Service::Engine::Engine.routes.draw do
    root to: "home#index"
    
    namespace :api do
        namespace :v1 do
            resources :project_environments, only: [:index, :create, :show, :destroy]
        end
    end
end
