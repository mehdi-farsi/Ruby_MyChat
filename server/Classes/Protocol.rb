# This class provide handler of functions.
# A function represent a command defined by the protocol

Packet = Struct.new(:id, :content)
Client = Struct.new(:name, :room, :socket)

class           Protocol
  def initialize
    puts "handler command is now ready"
  end

  def           nick(src_id, clients, packets, data)
    puts "Nick function"
    if (data.length == 2)
      clients.each_key do |key|
        packets << Packet.new(key, "toto42")
      end
      return packets, clients
    else
      puts "Usage: nick USERNAME"
    end    
  end

  def           broadcast_message(src_id, clients, packets, data)
    puts "broadcast_message function"
    if (data.length == 2)
      clients.each_key do |key|
        if (key != src_id)
          packets << Packet.new(key, "#{clients[src_id][:name]}: #{data[1]}")
        end
      end
      return packets
    else
      puts "Usage: broadcast_message MESSAGE"
    end
  end
end
