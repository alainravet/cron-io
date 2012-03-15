# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cron-io/version"

Gem::Specification.new do |s|
  s.name        = "cron-io"
  s.version     = CronIO::VERSION
  s.authors     = ["Alain Ravet"]
  s.email       = ["alain.ravet+github@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{a Ruby wrapper around cron.io services}
  s.description = %q{a Ruby wrapper around cron.io services}

  s.rubyforge_project = "cron-io"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "httparty"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "vcr", "1.11.3"
  s.add_development_dependency "fakeweb"
end
