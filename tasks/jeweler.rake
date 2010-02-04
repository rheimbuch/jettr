begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jettr"
    gem.summary = "Use Jetty from JRuby."
    gem.email = "rheimbuch@gmail.com"
    gem.homepage = "http://github.com/rheimbuch/persvr"
    gem.authors = ["Ryan Heimbuch"]
    
    gem.platform = 'java'
    
    gem.add_dependency 'configatron', ">=1.5.1"
    gem.add_dependency 'log4r', '>=1.1.4'
    gem.add_dependency 'thor'
    gem.add_dependency 'activesupport', "~>2.3.5"
  end
rescue LoadError
  puts "Jeweler no available. Install with: gem install jeweler"
end