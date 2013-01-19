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
    exist = false
    if (data.length >= 2)
      cmd = data[1].split(/\.?\s+/, 2)
      p clients
      clients.each_key do |key|
        exist = true if (clients[key][:name] == cmd[0])
      end
      #exist = clients.any? { |val| val[:name] == cmd[0] }
      if (exist == false)
        clients[src_id][:name] = cmd[0]
        packets << Packet.new(src_id, "your name is now ===> #{cmd[0]} !")
      else
        packets << Packet.new(src_id, "The nick #{cmd[0]} already exist")        
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
