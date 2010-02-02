module Jettr
  module Handler
    class SimpleHandler < Jettr::Handler::Base
      def initialize(response)
        super()
        @response = response
      end
      
      def handle(target, request, response, dispatch)
        puts "Handling request for: #{[target,request,response,dispatch].inspect}"
        response.content_type = "text/html;charset=utf-8"
        response.status = 200
    
        response.get_writer.println(@response)
        request.handled = true
      end
    end
  end
end