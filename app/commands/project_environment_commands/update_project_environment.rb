class ProjectEnvironmentCommands::UpdateProjectEnvironment
    include Zeus::Service::Engine::Concerns::Callable

    attr_accessor :current_env, :current_permissions, :id, :properties 

    def initialize(current_env, current_permissions, id, params)
        self.current_env = current_env
        self.current_permissions = current_permissions
        self.id = params[:id]
        self.properties = params[:properties]
    end

    def authorized?
        puts("#"*100)
        puts(@id.inspect, @current_permissions.inspect)
        puts("#"*100)
        
        return false if @id.blank?
        return false if @current_permissions !=PERMISSION_ZEUS
        true
    end

    def call
        # # Make sure it doesn't already exist
        # exists = Zeus::Service::Engine::ProjectEnvironment.where(project_id: @project_id, scope: @scope).exists?
        # return OpenStruct.new(success?: false, errors: ["Project environment already exists with that id and scope"]) if exists

        env = Zeus::Service::Engine::ProjectEnvironment.find(id)

        env.properties = env.properties.update(params[:properties]) if params[:properties].present?

        if env.save
            return OpenStruct.new(success?: true, payload: env)
        else 
            return OpenStruct.new(success?: false, errors: env.errors.full_messages)
        end
    end

    protected

end