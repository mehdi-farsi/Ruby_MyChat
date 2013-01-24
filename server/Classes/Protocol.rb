# This class provide handler of functions.
# A function represent a command defined by the protocol

Packet = Struct.new(:id, :content)
Client = Struct.new(:name, :room, :socket)

class           Protocol
  def initialize
    puts "handler command is now ready"
  end

  def           list(src_id, clients, packets, data)
    list_clients = ""
    clients.each_key do |key|
      if (clients[key][:name] != clients[src_id][:name])
        list_clients += "#{clients[key][:name]} "
      end
    end
    packets << Packet.new(src_id, "list #{list_clients}")
    return packets
  end

  def           nick(src_id, clients, packets, data)
    puts "Nick function"
    exist = false
    if (data[1].chomp != "")
      cmd = data[1].split(/\.?\s+/, 2)
      p clients
      clients.each_key do |key|
        exist = true if (clients[key][:name] == cmd[0])
      end
      if (exist == false)
        clients[src_id][:name] = cmd[0]
        packets << Packet.new(src_id, "nick YES #{cmd[0]}")
      else
        packets << Packet.new(src_id, "nick NO #{cmd[0]}")
      end
    else
      packets << Packet.new(src_id, "nick EMPTY")
    end
    return packets, clients
  end

  def           broadcast_msg(src_id, clients, packets, data)
    puts "broadcast message function"
    
    if (data[1].chomp != "")
      clients.each_key do |key|
        if (key != src_id)
          packets << Packet.new(key, "broadcast_msg (#{clients[src_id][:name]}[public])>>: #{data[1]}")
        end
        packets << Packet.new(key, "broadcast_msg OK")
      end
      return packets
    else
      packets << Packet.new(src_id, "broadcast_msg EMPTY")
    end
    return packets
  end

  def           private_msg(src_id, clients, packets, data)
    puts "private message function"
    if (data[1].chomp != "")
      cmd = data[1].split(/\.?\s+/, 2)
      if (data[1].chomp != "")
        clients.each_key do |key|
          if (key != src_id && clients[key][:name] == cmd[0])
            packets << Packet.new(key, "private_msg (#{clients[src_id][:name]}[private])>> #{cmd[1]}")
            break
          end
        end
        packets << Packet.new(src_id, "private_msg OK")
      else
        packets << Packet.new(src_id, "private_msg EMPTY")
      end
    else
      packets << Packet.new(src_id, "private_msg EMPTY")
    end
      return packets
  end
end
