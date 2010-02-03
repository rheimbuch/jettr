require 'thor'
require 'jettr'
require 'jettr/config'

module Jettr
  class Command < Thor
    
    desc "start [PATH] [--port=, --type=, --uri=]", "Start the webapp at PATH"
    method_option :port, :type => :numeric, :default => 8080, :alias => "-p"
    method_option :type, :type => :string, :default => "webapp", :alias => "-w"
    method_option :uri, :type => :string, :default => "/", :alias => "-u"
    def start(path=".")
      config = nil
      config_file = File.join(path,"jettr.yaml")
      if File.exist?(config_file)
        puts "Loading config file: #{config_file}"
        config = Jettr::Config.new(:config_file => config_file)
      else
        puts "Loading config..."
        config = Jettr::Config.new({
          :server => {
            :port => options[:port]
          },
          :apps => [
            {
              :type => options[:type],
              :app_path => path,
              :app_uri => options[:uri]
            }
          ]
        })
      end
      
      server = config.create_server
      puts "Starting Server..."
      server.start
    end
  end
end