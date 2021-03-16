class ProjectEnvironmentCommands::UpdateProjectEnvironment
    include Zeus::Service::Engine::Concerns::Callable

    attr_accessor :current_env, :current_permissions, :id, :properties 

    def initialize(current_env, current_permissions, id, params)
        self.current_env = current_env
        self.current_permissions = current_permissions
        self.id = id
        self.properties = params[:properties]
    end

    def authorized?
        return false if self.id.blank?
        return false if self.current_permissions != PERMISSION_ZEUS
        true
    end

    def call
        env = Zeus::Service::Engine::ProjectEnvironment.find(self.id)
        env.properties = env.properties.update(self.properties) if self.properties.present?

        if env.save
            return OpenStruct.new(success?: true, payload: env)
        else 
            return OpenStruct.new(success?: false, errors: env.errors.full_messages)
        end
    end

    protected

end