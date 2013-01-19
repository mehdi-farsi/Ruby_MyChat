# This class provide handler of functions.
# A function represent a command defined by the protocol

Packet = Struct.new(:id, :content)
Client = Struct.new(:name, :room, :socket)

class           Protocol
  def initialize
    puts "handler command is now ready"
  end

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
