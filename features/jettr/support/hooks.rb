After("@jettr","@server") do
  if @server
    @server.stop unless @server.stopped?
  end
end