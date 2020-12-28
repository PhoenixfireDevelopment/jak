# frozen_string_literal: true

# Jak namespace
module Jak
  # Engine class, as it's API JSON mode only
  class Engine < ::Rails::Engine
    isolate_namespace Jak

    # JSON mode only
    config.generators.api_only = true

    # Trick out our generators
    config.generators do |g|
      g.hidden_namespaces << :test_unit << :erb
      g.test_framework :rspec, fixture: false, view_specs: false
      g.integration_tool :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.assets false
      g.helper false
      g.request_specs false
      g.orm :mongoid
      g.scaffold_controller :jbuilder
    end

    # Shut mongodb up
    config.mongoid.logger.level = Logger::WARN

    #
    # Callbacks
    #
    # https://api.rubyonrails.org/classes/Rails/Railtie/Configuration.html

    # First configurable block to run. Called before any initializers are run.
    config.before_configuration do
      Jak::Middleware::Proxy.before_configuration.call
    end

    # Second configurable block to run. Called before frameworks initialize.
    config.before_initialize do
      Jak::Middleware::Proxy.before_initialize.call
    end

    # Third configurable block to run. Does not run if config.eager_load set to false.
    config.before_eager_load do
      Jak::Middleware::Proxy.before_eager_load.call
    end

    # Sends the initializers to the initializer method defined in the Rails::Initializable
    # module. Each Rails::Application class has its own set of initializers, as defined
    # by the Initializable module.
    initializer 'jak.to_prepare' do
      Jak::Middleware::Proxy.jak_engine_to_prepare.call
    end

    # Defines generic callbacks to run before after_initialize. Useful for Rails::Railtie subclasses.
    config.to_prepare do
      Jak::Middleware::Proxy.to_prepare.call
    end

    # Last configurable block to run. Called after frameworks initialize.
    config.after_initialize do
      Jak::Middleware::Proxy.after_initialize.call
    end

    #
    # End Callbacks
    #
  end
end
