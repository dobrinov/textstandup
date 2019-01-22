require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module TextStandup
  class Application < Rails::Application
    config.load_defaults 5.2
    config.generators.system_tests = nil
    config.active_record.schema_format = :sql
  end
end
