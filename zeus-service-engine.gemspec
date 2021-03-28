require_relative "lib/zeus/service/engine/version"

Gem::Specification.new do |spec|
  spec.name        = "zeus-service-engine"
  spec.version     = Zeus::Service::Engine::VERSION
  spec.authors     = ["Eric Campbell"]
  spec.email       = ["ericcampbell59@gmail.com"]
  spec.homepage    = "https://www.zeusdev.io"
  spec.summary     = "Common components between Zeus services."
  spec.description = "Common components between Zeus services."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://www.zeusdev.io"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.1"
  spec.add_dependency "zeus_sdk", ">= 0.6.2"
end
