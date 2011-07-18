# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rspec-tropo2/version"

Gem::Specification.new do |s|
  s.name        = %q{rspec-tropo2}
  s.version     = RSpecTropo2::VERSION
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ["MIT"]
  s.authors     = ["Jason Goecke"]
  s.email       = %q{jsgoecke@voxeo.com}
  s.homepage    = %q{http://github.com/tropo/rspec-tropo2}
  s.summary     = %q{Rspec2 for Tropo2}
  s.description = %q{Rspec2 Matchers for Tropo2}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency %q<rspec>, [">= 2.6.0"]
  s.add_dependency %q<punchblock>, [">= 0.1.0"]
  s.add_dependency %q<countdownlatch>, [">= 1.0.0"]

  s.add_development_dependency %q<yard>, ["~> 0.6.0"]
  s.add_development_dependency %q<bundler>, ["~> 1.0.0"]
  s.add_development_dependency %q<rcov>, [">= 0"]
  s.add_development_dependency %q<rake>, [">= 0"]
end
