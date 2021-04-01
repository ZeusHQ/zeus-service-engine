class Zeus::Service::Engine::Api::V1::ProjectEnvironmentsController < Zeus::Service::Engine::ApplicationController
    before_action :authorize_api_request!
    before_action :require_zeus_permissions!

    CLASS_NAME = "Zeus::Service::Engine::ProjectEnvironment"

    def index
        environments = Zeus::Service::Engine::ProjectEnvironment.where(id: params[:ids]).all
        render_resources(environments, CLASS_NAME)
    end

    def show
        env = Zeus::Service::Engine::ProjectEnvironment.find(params[:id])
        render_resource(env.as_json(include_keys: true), CLASS_NAME)
    end

    def create
        res = ProjectEnvironmentCommands::CreateProjectEnvironment.call(current_env, current_permissions, create_params)

        if res.success?
            render_resource(res.payload.as_json(include_keys: true), CLASS_NAME)
        else
            render_error(res.errors)
        end
    end

    def update
        res = ProjectEnvironmentCommands::UpdateProjectEnvironment.call(current_env, current_permissions, params[:id], update_params)

        if res.success?
            render_resource(res.payload, CLASS_NAME)
        else
            render_error(res.errors)
        end
    end

    def destroy
        res = ProjectEnvironmentCommands::DestroyProjectEnvironment.call(current_env, current_permissions, params[:id])

        if res.success?
            render_resource(res.payload, CLASS_NAME)
        else
            render_error(res.errors)
        end
    end

    protected
    def create_params
        params.require(:project_environment).permit(:scope, :name, properties: {})
    end

    def update_params
        params.require(:project_environment).permit(:name, properties: {})
    end
end