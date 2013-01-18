# This class Provide handler of functions.
# A function represent a command defined by the protocol

Packet = Struct.new(:id, :content)
Client = Struct.new(:name, :room, :socket)

class           Protocol
  def initialize
    puts "handler command is now ready"
  end

  # :src user that emit packet
  # :clients list of online clients
  # :packets list of packets ready to be send
  # :data content to be treated
  def           broadcast_message(client, clients, packets, data)
    if (data.length == 2)
      clients.each_key do |key|
        packets << Packet.new(key, "toto42")
      end
      return packets
    else
      puts "Usage: broadcast_message MESSAGE"
    end
  end
end
