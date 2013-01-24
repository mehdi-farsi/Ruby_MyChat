# This class implement the Network layer of the server.

require         'socket'
require         'Classes/Protocol'

class           Network
  
  def           initialize(port)
    @id_users = 1
    @handler_function = Protocol.new
    @port = port
    # Used only in select()
    @fds = []
    # Used for the Protocol part
    # In order to ease the communication
    # Between each client
    @clients = Hash.new("Clients manager")
    @packets = Array.new
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
    rescue Interrupt
      puts "\nBye Bye !"
    ensure
      @fds.each {|c| c.close}
    end
  end

  private
  def           readable(reads, acceptor)
    src_id = "R2D2"
    reads.each do |client|
      @clients.each_key do |key|
        if (@clients[key][:socket].object_id.to_s == client.object_id.to_s)
          src_id = key
        end
      end
      # New client
      if client == acceptor
        new_client(acceptor)
      elsif client.eof?
        disconnect_client(client, src_id)
        # Readable socket
      else
        cmd = client.gets("\n")
        handler_function(cmd, src_id)
      end
    end
  end

  def write_packets
    if (@packets.empty? == false)
      @clients.each_key do |key|
        @packets.each_index do |i|
          if (@packets[i][:id].to_s == key.to_s)
            @clients[key][:socket].puts(@packets[i][:content])
            puts "packet sent to user #{key} : #{@packets[i][:content]}"
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
    @clients[@id_users] = Client.new("guest#{@id_users}", "all", new_client)
    @packets << Packet.new(@id_users, @clients[@id_users][:name])
    @id_users += 1
  end

  def           disconnect_client(client, src_id)
    puts "Bye bye !"
    @fds.delete(client)
    @clients.each_key do |key|
      if (key != src_id)
        @packets << Packet.new(key, "#{@clients[src_id][:name]} is disconnected !")
      end
    end
    @clients.delete(src_id)
    client.close
  end

  def           handler_function(cmd, src_id)
    data = cmd.split(/\.?\s+/, 2)
    if (data[0].empty? == false)
      if (@handler_function.respond_to?(data[0]))
        if (data[0] == "name")
          @packets, @clients = @handler_function.send(data[0].to_sym, src_id,
                                                      @clients, @packets, data)
        else
          @packets = @handler_function.send(data[0].to_sym, src_id,
                                            @clients, @packets, data)
        end
      else
        @packets << Packet.new(src_id, "Command #{data[0]} doesn't exist !")
      end
    end
  end

end
