class ProjectEnvironmentCommands::CreateProjectEnvironment
    include Zeus::Service::Engine::Concerns::Callable

    attr_accessor :current_env, :current_permissions, :properties, :name #:project_id, :scope, 

    def initialize(current_env, current_permissions, params)
        self.current_env = current_env
        self.current_permissions = current_permissions
        # self.project_id = params[:project_id]
        # self.scope = params[:scope]
        self.properties = params[:properties] || {}
        self.name = params[:name] || {}
    end

    def authorized?
        # return false if @project_id.blank?
        return false if @current_permissions != PERMISSION_ZEUS
        true
    end

    def call
        # # Make sure it doesn't already exist
        # exists = Zeus::Service::Engine::ProjectEnvironment.where(project_id: @project_id, scope: @scope).exists?
        # return OpenStruct.new(success?: false, errors: ["Project environment already exists with that id and scope"]) if exists

        env = Zeus::Service::Engine::ProjectEnvironment.new(properties: self.properties, name: self.name)

        if env.save
            return OpenStruct.new(success?: true, payload: env)
        else 
            return OpenStruct.new(success?: false, errors: env.errors.full_messages)
        end
    end

    protected

end