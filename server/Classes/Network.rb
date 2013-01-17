require 'socket'

class Network
  
  def initialize(port)
    @port = port
    @fds = []
    puts "Network.initialize"
  end

  def main_loop
    begin
      # Create a TCPServer. 0.0.0.0 => all IP address.
      acceptor = TCPServer.open('0.0.0.0', @port)
      # Initialize an array with server socket
      @fds << acceptor
      while (true)
        if socket_descriptors = select(@fds, [], [], 10)
          # socket_descriptors.first contain a collection of readable sockets
          reads = socket_descriptors.first
          reads.each do |client|
            # New client
            if client == acceptor
              new_client(acceptor)
            elsif client.eof?
              disconnect_client(client)
              # Readable socket
            else
              p client.gets("\n")
            end
          end
        end
      end
    ensure
      @fds.each {|c| c.close}
    end
  end

  private
  def new_client(acceptor)
    new_client = acceptor.accept
    puts "New client !"
    @fds << new_client
  end

  def disconnect_client(client)
    puts "Bye bye !"
    @fds.delete(client)
    client.close    
  end
end
