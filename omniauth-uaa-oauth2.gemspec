# -*- encoding: utf-8 -*-
#
# Cloud Foundry 2012.02.03 Beta
# Copyright (c) [2009-2012] VMware, Inc. All Rights Reserved.
#
# This product is licensed to you under the Apache License, Version 2.0 (the "License").
# You may not use this product except in compliance with the License.
#
# This product includes a number of subcomponents with
# separate copyright notices and license terms. Your use of these
# subcomponents is subject to the terms and conditions of the
# subcomponent's license, as noted in the LICENSE file.
#

require File.expand_path('../lib/omniauth/uaa_oauth2/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'cf-uaa-client', '~> 1.2'

  gem.authors       = ["Joel D'sa", "Dave Syer", "Dale Olds", "Vidya Valmikinathan", "Luke Taylor"]
  gem.email         = ["jdsa@vmware.com", "olds@vmware.com", "dsyer@vmware.com", "vidya@vmware.com", "ltaylor@vmware.com"]
  gem.description   = %q{An OmniAuth strategy for the Cloudfoundry UAA}
  gem.summary       = %q{An OmniAuth strategy for the Cloudfoundry UAA}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-uaa-oauth2"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::CloudFoundry::VERSION

  gem.add_runtime_dependency 'cf-uaa-client'

  gem.add_development_dependency 'rspec', '~> 2.6.0'
  gem.add_development_dependency 'rake'
end
