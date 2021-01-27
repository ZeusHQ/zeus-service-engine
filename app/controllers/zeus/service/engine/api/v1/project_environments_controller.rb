class Zeus::Service::Engine::Api::V1::ProjectEnvironmentsController < Zeus::Service::Engine::ApplicationController
    def index
        render json: {error: "Missing project_id"} and return if params[:project_id].blank?
        environments = Zeus::Service::Engine::ProjectEnvironment.where(project_id: params[:project_id]).all
        render json: environments
    end

    def create
        res = ProjectEnvironmentCommands::CreateProjectEnvironment.call(current_env, current_permissions, create_params)
        if res.success?
            render json: res.payload.as_json(include_keys: true)
        else
            render_struct(res)
        end
    end

    protected
    def create_params
        params.require(:project_environment).permit(:project_id, :scope)
    end
end