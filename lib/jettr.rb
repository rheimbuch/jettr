$:.unshift(File.expand_path(File.dirname(__FILE__))) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'java'

module Jettr
  JETTR_HOME = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined? JETTR_HOME
end

require 'jettr/logger'
require 'jettr/jars'
require 'jettr/server'
