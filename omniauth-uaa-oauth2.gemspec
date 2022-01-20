# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth/uaa_oauth2/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dr Nic Williams", "Joel D'sa", "Dave Syer", "Dale Olds", "Vidya Valmikinathan", "Luke Taylor"]
  gem.email         = ["drnicwilliams@gmail.com", "jdsa@vmware.com", "olds@vmware.com", "dsyer@vmware.com", "vidya@vmware.com", "ltaylor@vmware.com"]
  gem.description   = %q{An OmniAuth strategy for the Cloud Foundry UAA}
  gem.summary       = %q{An OmniAuth strategy for the Cloud Foundry UAA}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-uaa-oauth2"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Cloudfoundry::VERSION

  gem.add_runtime_dependency 'omniauth', '~> 1.0'
  gem.add_runtime_dependency 'cf-uaa-lib', ['>= 3.2', '< 5.0']

  gem.add_development_dependency 'rspec', '~> 2.6.0'
  gem.add_development_dependency 'rake'
end
