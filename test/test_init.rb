ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

ENV['ENTITY_CACHE_SCOPE'] ||= 'exclusive'

require_relative '../init.rb'

require 'raygun_client/controls'
require 'ostruct'

require 'test_bench/activate'

require 'pp'

include RaygunClient
