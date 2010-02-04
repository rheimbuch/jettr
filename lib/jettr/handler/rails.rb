require 'jettr/handler/web_app'

module Jettr
  module Handler
    class Rails < Jettr::Handler::WebApp      
      def initialize(options={})
        super(options)
        config.rails.set_default(:root, '/')
        config.rails.set_default(:public, '/public')
        config.rails.set_default(:min_runtimes, 1)
        config.rails.set_default(:max_runtimes, 3)
        config.rails.set_default(:environment, "development")
        
        
        self.add_filter("org.jruby.rack.RackFilter", "/*", org.mortbay.jetty.Handler::DEFAULT)
        self.resource_base = "#{config.app_path}"
        self.add_event_listener(Jettr::Rack::RailsServletContextListener.new)
        rack_params = java.util.HashMap.new({
          'rails.env' => config.rails.environment,
          'rails.root' => config.rails.root,
          'public.root' => config.rails.public,
          'org.mortbay.jetty.servlet.Default.relativeResourceBase' => '/public',
          'jruby.min.runtimes' => config.rails.min_runtimes.to_s,
          'jruby.max.runtimes' => config.rails.max_runtimes.to_s,
          'jruby.initial.runtimes' => config.rails.min_runtimes.to_s 
        })
        self.set_init_params(rack_params)
        self.add_servlet(Jetty::ServletHolder.new(Jetty::DefaultServlet.new), "/")
      end
    end
  end
end