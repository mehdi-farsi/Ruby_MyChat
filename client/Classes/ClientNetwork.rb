# This class implement the Network layer of the server.


require         'socket'
require         'Classes/Protocol'

Client = Struct.new(:name, :room)

class           ClientNetwork

  def             initialize(address, port)
    @socket_server
    @port = port
    @address = address
    @handler_function = Protocol.new
    @fds = []
  end

  def           main_loop
    begin
      @socket_server = TCPSocket.open(@address, @port)
      @client = Client.new("guest", "all")
      packet = @socket_server.gets
      @client[:name] = packet.split(/\.?\s+/).first
      puts "You are now connected on MyChat #{@address}:#{@port} with nick #{@client[:name]}"
      @fds << @socket_server
      @fds << STDIN
      # Activation of real-time displaying
      STDOUT.sync = true
      print "(#{@client[:name]})>> "
      while (true)
        if (socket_descriptors = select(@fds, [], []))
          readable(socket_descriptors.first)
        end
      end
    ensure
      @socket_server.close
    end
  end

  private
  
  def             readable(reads)
    reads.each do |client|
      if (client.object_id.to_s == @socket_server.object_id.to_s)
        get_reply_server(client)
        print "(#{@client[:name]})>> "
      else
        cmd = STDIN.gets
        if (cmd.chomp.empty? == false)
          @socket_server.puts(cmd)
        else
          print "(#{@client[:name]})>> "
        end
      end
    end
  end
  
  def           get_reply_server(client)
    data = client.gets
    handler_function(data)
  end

  def           handler_function(cmd)
    data = cmd.chomp.split(/\.?\s+/, 2)
    if (data[0].empty? == false)
      if (@handler_function.respond_to?(data[0]))
        @packets = @handler_function.send(data[0].to_sym, data)
      else
        print "MyChat [#{@address}:#{@port}] => #{cmd}\n"
      end
    end
  end
  
  
end
