require 'configatron'
require 'jettr/server'
require 'jettr/handler'

module Jettr
  class Config
    attr_reader :config
    def initialize(options={})
      @config = Configatron::Store.new
      if options[:config_file] && File.exist?(options[:config_file])
        config.configure_from_yaml(options[:config_file])
        config.base_path = File.expand_path(File.dirname(options[:config_file]))
      else
        config.configure_from_hash(options)
      end
      config.server.set_default(:port, 8080)
      config.set_default(:apps, [])
      puts "Config initialized..."
    end
    
    def create_server
      puts "Creating server..."
      server = Jettr::Server.new(config.server.to_hash)
      config.apps.each do |app_config|
        if app_config[:app_path] && config.exists?(:base_path)
          app_config[:app_path] = File.join(config.base_path, app_config[:app_config])
        end
        server.handlers << create_app(app_config)
        puts "Added handler: #{server.handlers.last.inspect}"
      end
      server
    end
    
    def create_app(app_config)
      puts "Creating app handler: #{app_config.inspect}"
      app_type = app_config.delete(:type)
      app_type = app_type ? app_type.to_sym : app_type
      handler_class = Jettr::Handler::HANDLERS[app_type] || Jettr::Handler::HANDLERS[:default]
      handler_class.new(app_config)
    end
  end
end