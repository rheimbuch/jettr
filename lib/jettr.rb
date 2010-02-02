$:.unshift(File.expand_path(File.dirname(__FILE__))) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'java'
require 'log4r'

module Jettr
  JETTR_HOME = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined? JETTY_HOME
  Logger = Log4r::Logger
  Logger.new self.name
end
require 'jettr/jars'
require 'jettr/server'
