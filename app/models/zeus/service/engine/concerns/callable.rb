# module Zeus::Service::Engine::Concerns::Callable
#     extend ActiveSupport::Concern
#     class_methods do
#         def call(*args)
#             new(*args).call
#         end
#     end
# end

class Zeus::Service::Engine::InvalidAuthorization < StandardError
    def initialize(resource)
         @resource = resource
    end
 
    def message
         "Not authorized to access: #{@resource}"
    end
 end
 
 module Zeus::Service::Engine::Concerns::Callable
     extend ActiveSupport::Concern
     class_methods do
         def call(*args)
             obj = new(*args)
             raise Zeus::Service::Engine::InvalidAuthorization.new(self.name) unless obj.authorized? 
             obj.call
         end
     end
 end