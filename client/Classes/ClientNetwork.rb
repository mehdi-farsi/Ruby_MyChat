# This class implement the Network layer of the server.


require         'socket'
#require         'Classes/Protocol'

Client = Struct.new(:name, :room)

class           ClientNetwork

  def             initialize(address, port)
    @socket_server
    @port = port
    @address = address
 #   @handler_function = Protocol.new
    @fds = []
  end

  def           main_loop
    begin
      @socket_server = TCPSocket.open(@address, @port)
      @client = Client.new("guest", "all")
      packet = @socket_server.gets
      @client[:name] = packet.split(/\.?\s+/).first
      puts "You are now connected in server #{@address}:#{@port} with nick #{@client[:name]}"
      @socket_server.close
    ensure
      #TCPSocket s = @client[:socket]

    end
  end
end
