require         'socket'
require         'Classes/Protocol'

class           Network
  
  def           initialize(port)
    @handler_function = Protocol.new
    @port = port
    @fds = []
    @packets = []
    puts "Network.initialize"
  end

  def           main_loop
    begin
      # Create a TCPServer. 0.0.0.0 => all IP address.
      acceptor = TCPServer.open('0.0.0.0', @port)
      # Initialize an array with server socket
      @fds << acceptor
      while (true)
        if socket_descriptors = select(@fds, @fds, [], 10)
          # socket_descriptors.first contain a collection of readable sockets
          readable(socket_descriptors.first, acceptor)
          writable(socket_descriptors[1])
        end
      end
    ensure
      @fds.each {|c| c.close}
    end
  end

  private
  def           readable(reads, acceptor)
    reads.each do |client|
      # New client
      if client == acceptor
        new_client(acceptor)
      elsif client.eof?
        disconnect_client(client)
        # Readable socket
      else
        cmd = client.gets("\n")
        p "Received: " + cmd
        handler_function(cmd, client)
      end
    end
  end

  def writable(writes)
    writes.each do |client|
      @packets.each_index do |i|
        if (@packets[i][:id].to_s == client.object_id.to_s)
          client.puts(@packets[i][:content])
          @packets.delete_at(i)
        end
      end
    end
  end

  def           new_client(acceptor)
    new_client = acceptor.accept
    puts "New client !"
    @fds << new_client
  end

  def           disconnect_client(client)
    puts "Bye bye !"
    @fds.delete(client)
    client.close    
  end

  def handler_function(cmd, client)
    data = cmd.split(/\.?\s+/, 2)
    p data
    if (data[0].empty? == false)
      if (@handler_function.respond_to?(data[0]))
        @packets = @handler_function.send(data[0].to_sym, data, client, @packets)
      else
        puts "Command #{data[0]} doesn't exist !"
      end
    end
  end

end
