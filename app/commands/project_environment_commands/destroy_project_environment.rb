class ProjectEnvironmentCommands::DestroyProjectEnvironment
    include Zeus::Service::Engine::Concerns::Callable

    attr_accessor :current_env, :current_permissions, :id

    def initialize(current_env, current_permissions, id)
        self.current_env = current_env
        self.current_permissions = current_permissions
        self.id = id
    end

    def authorized?
        return false if @id.blank?
        return false if @current_permissions != "zeus"
        true
    end

    def call
        # # Make sure it doesn't already exist
        # exists = Zeus::Service::Engine::ProjectEnvironment.where(project_id: @project_id, scope: @scope).exists?
        # return OpenStruct.new(success?: false, errors: ["Project environment already exists with that id and scope"]) if exists

        env = Zeus::Service::Engine::ProjectEnvironment.find(id)
        cloned = env.clone
        if env.destroy
            return OpenStruct.new(success?: true, payload: cloned)
        else 
            return OpenStruct.new(success?: false, errors: env.errors.full_messages)
        end
    end

    protected

end