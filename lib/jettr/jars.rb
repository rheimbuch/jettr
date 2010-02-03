module Jettr
  require "jettr/jars/servlet-api-2.5-6.1.14"
  require "jettr/jars/jetty-6.1.14"
  require "jettr/jars/jetty-util-6.1.14"
  require "jettr/jars/jetty-plus-6.1.14"
  require "jettr/jars/core-3.1.1"
  require "jettr/jars/jsp-api-2.1"
  require "jettr/jars/jsp-2.1"
  require "jettr/jars/jruby-rack-0.9.6"
  require "jettr/jars/jettr-java"
  require "jettr/jars/akuma-1.3-jar-with-dependencies.jar"
  
  module Jetty
    include_package "org.mortbay.jetty"
    include_package "org.mortbay.jetty.servlet"
    include_package "org.mortbay.jetty.nio"
    include_package "org.mortbay.resource"
  
    module Handler
      include_package "org.mortbay.jetty.handler"
      include_package "org.mortbay.jetty.webapp"
    end
  
    module Thread
      include_package "org.mortbay.thread"
    end
  end
  
  module Resource
    include_class 'persvr.InheritingFileResource'
  end
  
  module Rack
    include_package "org.jruby.rack"
    include_package "org.jruby.rack.rails"
  end
  module Akuma
    include_package "com.sun.akuma"
  end
end