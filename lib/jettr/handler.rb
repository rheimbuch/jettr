

module Jettr
  module Handler
  end
end

require 'jettr/handler/base'
require 'jettr/handler/web_app'
require 'jettr/handler/rails'

Jettr::Handler::HANDLERS = HashWithIndifferentAccess.new({
  :default => Jettr::Handler::WebApp,
  :webapp => Jettr::Handler::WebApp,
  :rails => Jettr::Handler::Rails
})