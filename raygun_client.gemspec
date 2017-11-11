# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'raygun_client'
  s.version = '0.6.1.0'
  s.summary = 'Client for the Raygun API using the Obsidian HTTP client'
  s.description = ' '

  s.authors = ['Nathan Ladd']
  s.email = 'nathanladd@gmail.com'
  s.homepage = 'https://github.com/btc-labs/firebase-client'
  s.licenses = ['Proprietary']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.4.0'

  s.add_runtime_dependency 'evt-configure'
  s.add_runtime_dependency 'evt-schema'
  s.add_runtime_dependency 'evt-settings'
  s.add_runtime_dependency 'evt-transform'
end
