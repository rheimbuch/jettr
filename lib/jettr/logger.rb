require 'log4r'
module Jettr
  Logger = Log4r::Logger
  Logger.new self.name
end