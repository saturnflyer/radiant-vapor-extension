# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-vapor-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-vapor-extension"
  s.version     = RadiantVaporExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = RadiantVaporExtension::AUTHORS
  s.email       = RadiantVaporExtension::EMAIL
  s.homepage    = RadiantVaporExtension::URL
  s.summary     = RadiantVaporExtension::SUMMARY
  s.description = RadiantVaporExtension::DESCRIPTION

  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  # s.executables   = Dir['bin/*'] - ignores
  s.require_paths = ["lib"]
end
