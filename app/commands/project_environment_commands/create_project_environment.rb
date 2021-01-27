class ProjectEnvironmentCommands::CreateProjectEnvironment
    include Zeus::Service::Engine::Concerns::Callable

    attr_accessor :current_env, :current_permissions, :project_id, :scope

    def initialize(current_env, current_permissions, params)
        self.current_env = current_env
        self.current_permissions = current_permissions
        self.project_id = params[:project_id]
        self.scope = params[:scope]
    end

    def call
        return OpenStruct.new(success?: false, errors: ["Missing project_id"]) if @project_id.blank?
        return OpenStruct.new(success?: false, errors: ["Invalid permissions"]) if @current_permissions != "zeus"

        # Make sure it doesn't already exist
        exists = Zeus::Service::Engine::ProjectEnvironment.where(project_id: @project_id, scope: @scope).exists?
        return OpenStruct.new(success?: false, errors: ["Project environment already exists with that id and scope"]) if exists

        env = Zeus::Service::Engine::ProjectEnvironment.new(project_id: @project_id, scope: @scope)

        if env.save
            return OpenStruct.new(success?: true, payload: env)
        else 
            return OpenStruct.new(success?: false, errors: payload.errors.full_messages)
        end
    end

    protected

end