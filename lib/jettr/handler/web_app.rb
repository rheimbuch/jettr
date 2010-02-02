require 'configatron'
module Jettr
  module Handler
    class WebApp < Jetty::Handler::WebAppContext
      attr_reader :config
      
      def initialize(options={})
        super()
        @config = Configatron::Store.new
        config.configure_from_hash(options)
        config.set_default(:app_path, ".")
        config.set_default(:app_uri, "/")
        self.context_path = config.app_uri
        self.war = config.app_path
      end
    end
  end
end