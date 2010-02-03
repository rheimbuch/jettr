require 'thor'
require 'jettr'
require 'jettr/config'
require 'fileutils'

module Jettr
  class Command < Thor
    
    desc "start [PATH] [--port=, --type=, --uri=]", "Start the webapp at PATH"
    method_option :port, :type => :numeric, :default => 8080, :aliases => "-p"
    method_option :type, :type => :string, :default => "webapp", :aliases => "-w"
    method_option :uri, :type => :string, :default => "/", :aliases => "-u"
    method_option :daemon, :type => :boolean, :default => false, :aliases => "-d"
    method_option :pid, :type => :string
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
      
      if(options[:daemon])
        d = Jettr::Akuma::Daemon.new
        pid_file = File.expand_path(options[:pid] || File.join(path,'tmp','run',"jettr.pid"))
        if(d.daemonized?)
          if File.exist?(pid_file)
            puts "Pid file alread exists at: #{pid_file}"
            puts "run `jettr stop #{pid_file}` to ensure the process has been stopped."
            exit 1
          end
          FileUtils.mkdir_p File.dirname(pid_file)
          puts "PID File: #{pid_file}"
          d.init(pid_file)
        else
          d.daemonize()
          exit 0
        end
      end
      server = config.create_server
      puts "Starting Server..."
      server.start
    end
    
    desc "stop PATH_TO_APP_OR_PID", "Stops the daemonized jettr instance."
    def stop(path='.')
      pid_file = File.directory?(path) ? File.join(path, 'tmp','run','jettr.pid') : path
      unless File.exist?(pid_file)
        puts "Pid file not found: #{pid_file}"
        exit 1
      end
      File.open(pid_file) do |file|
        pid = file.read.strip.to_i
        res = Process.kill("SIGINT", pid)
        puts "Jettr process #{pid} was killed with response #{res}"
      end
      FileUtils.rm_rf pid_file
    end
  end
end