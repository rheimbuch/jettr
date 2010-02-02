require 'jettr'
require 'open-uri'
require 'socket'
require 'jettr/handler/simple_handler'

Given /^"([^\"]*)" servers exist$/ do |arg1|
end

When /^I create a server "([^\"]*)" "([^\"]*)"$/ do |with_without, arguments|
  has_arguments = with_without == "with" ? true : false
  if has_arguments
    @server = eval "Jettr::Server.new(#{arguments})"
  else
    @server = Jettr::Server.new
  end
end

When /^I "([^\"]*)" the server$/ do |cmd|
  @server.should respond_to cmd.to_sym
  @server.send(cmd)
end

When /^port "([^\"]*)" is already in use$/ do |port|
  @open_port = TCPServer.open(port.to_i)
end


When /^I add a handler that responds with "([^\"]*)"$/ do |response|
  @server.handlers << Jettr::Handler::SimpleHandler.new(response)
end

Then /^the server should be "([^\"]*)"$/ do |status|
  @server.should eval("be_#{status}")
end

Then /^the server should be configured to run on port "([^\"]*)"$/ do |port|
  @server.config.port.should == port.to_i
end

Then /^the server should have "([^\"]*)" handlers$/ do |num|
  @server.handlers.size.should == num.to_i
end

Then /^the handler should respond with "([^\"]*)" on port "([^\"]*)"$/ do |expected, port|
  open("http://localhost:#{port}") do |resp|
    resp.read.strip.should == expected
  end
end

Then /^"([^\"]*)" should be raised when I "([^\"]*)" the server$/ do |exception_name, action|
  @server.should respond_to(action)
  lambda {
    @server.send(action)
  }.should raise_error
end


