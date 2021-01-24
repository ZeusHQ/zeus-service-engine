class Zeus::Service::Engine::Api::V1::ProjectEnvironmentsController < Zeus::Service::Engine::ApplicationController
    def index
        render json: {error: "Missing project_id"} and return if params[:project_id].blank?
        environments = Zeus::Service::Engine::ProjectEnvironment.where(project_id: params[:project_id]).all
        render json: environments
    end
end