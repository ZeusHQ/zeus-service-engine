Zeus::Service::Engine::Engine.routes.draw do
    root to: "home#index"

    namespace :admin do
        resources :project_environments
    end
    
    namespace :api do
        namespace :v1 do
            resources :project_environments
        end
    end
end
