$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cdot_camera/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cdot_camera"
  s.version     = CdotCamera::VERSION
  s.authors     = ["Skylar Bolton"]
  s.email       = ["sbolton@bcimedia.com"]
  s.summary     = %q{CDOT webcams}
  s.description = %q{Just the still ones.}
  s.homepage    = "https://github.com/BallantineDigitalMedia/cdot_cameras"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.2.8"

  s.add_development_dependency "sqlite3"
end
