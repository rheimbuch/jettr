require 'configatron'
require 'jettr/handler'
module Jettr
  class Server
    attr_reader :config, :handlers, :server
    Logger.new self.name
    
    include_class java.net.BindException
    
    def initialize(options={})
      @server = Jetty::Server.new
      @handlers = HandlerCollectionProxy.for(@server)
      configure(options)
    end
    
    def configure(options_or_file,opts={})
      @config ||= Configatron::Store.new
      @config.set_default(:name, "ObjectId:#{self.object_id}")
      @config.set_default(:port, 8080)
      @config.set_default(:acceptors, 5)
      @config.thread_pool.set_default(:max, 20)
      @config.thread_pool.set_default(:min, 1)
      @config.shutdown.set_default(:graceful, false)
      @config.shutdown.set_default(:graceful_timeout, 500)
      case options_or_file
      when String then @config.configure_from_yaml(options_or_file,opts)
      when Hash then @config.configure_from_hash(options_or_file)
      end
                                        
      configure_jetty
    end
    
    def start
      begin
        if stopped?
          logger.info "Starting server..."
          @server.start
        end
      rescue BindException => ex
        stop
        raise ex
      end
    end
    
    def stop
      if running? || failed?
        logger.info "Stopping server..."
        @server.stop
      else
        logger.debug "#stop: Server already stopped."
      end
    end
    
    def restart
      logger.info "Restarting server..."
      stop
      until stopped?
        logger.debug "#restart: waiting for server to stop..."
        sleep 0.2
      end
      start
    end
    
    def destroy
      @server.stop unless stopped?
      @server.destroy()
      @destroyed = true
    end
    
    def running?
      @server.isRunning
    end
    
    def stopped?
      @server.isStopped
    end
    
    def failed?
      @server.isFailed
    end
    
    def destroyed?
      @destroyed ||=false
    end
    
    def join
      logger.debug "Joining server thread..."
      @server.join
    end
    
    private
    def configure_jetty
      thread_pool = Jetty::Thread::QueuedThreadPool.new
      thread_pool.set_max_threads(config.thread_pool.max)
      thread_pool.set_min_threads(config.thread_pool.min)
      @server.set_thread_pool(thread_pool)
      
      connector = Jetty::SelectChannelConnector.new
      connector.set_acceptors(config.acceptors)
      connector.port = config.port
      @server.add_connector(connector)
      
      @server.stop_at_shutdown = config.shutdown.graceful
      @server.graceful_shutdown = config.shutdown.graceful_timeout
    end
    
    def logger
      @logger ||= Logger.new("#{self.class.name}::#{config.name}")
    end
    
    class HandlerCollectionProxy
      def initialize(server)
        @server = server
        @handlers = []
      end
      
      def self.for(server)
        self.new(server)
      end
      
      private
      def method_missing(method, *args, &block)
        handlers_orig = @handlers.clone
        res = @handlers.send(method, *args, &block)
        if @handlers != handlers_orig
          @handlers.flatten! # Ensure the mutation operation didn't introduce nesting.
          @server.set_handlers(@handlers.to_java(Jettr::Handler::Base))
        end
        return res
      end
    end
    
  end
end