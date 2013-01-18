require         'socket'
require         'Classes/Protocol'

class           Network
  
  def           initialize(port)
    @id_users = 1
    @handler_function = Protocol.new
    @port = port
    @fds = []
    @packets = Array.new
    @clients = Hash.new("Clients manager")
    puts "Network.initialize"
  end

  def           main_loop
    begin
      # Create a TCPServer. 0.0.0.0 => all IP address.
      acceptor = TCPServer.open('0.0.0.0', @port)
      # Initialize an array with server socket
      @fds << acceptor
      while (true)
        if socket_descriptors = select(@fds, [], [], 10)
          # socket_descriptors.first contain a collection of readable sockets
          readable(socket_descriptors.first, acceptor)
          write_packets
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

  def write_packets
    if (@packets.empty? == false)
      @clients.each_key do |key|
        @packets.each_index do |i|
          puts "fds->packet(#{@packets[i][:id].to_s})"
          puts "fds->client(#{@clients[key].to_s})"
          if (@packets[i][:id].to_s == key.to_s)
            @clients[key][:socket].puts(@packets[i][:content])
            @packets.delete_at(i)
          end
        end
      end
    end
  end

  def           new_client(acceptor)
    new_client = acceptor.accept
    puts "New client !"
    @fds << new_client
    @clients[@id_users] = Client.new("guest", "all", new_client)
    @id_users += 1
  end

  def           disconnect_client(client)
    puts "Bye bye !"
    @fds.delete(client)
    client.close    
  end

  def handler_function(cmd, client)
    data = cmd.split(/\.?\s+/, 2)
    if (data[0].empty? == false)
      if (@handler_function.respond_to?(data[0]))
        @packets = @handler_function.send(data[0].to_sym, client,
                                          @clients, @packets, data)
      else
        puts "Command #{data[0]} doesn't exist !"
      end
    end
  end

end
