module Zeus
  module Service
    module Engine
      class Engine < ::Rails::Engine
        isolate_namespace Zeus::Service::Engine
      end
    end
  end
end
