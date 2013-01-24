# This class provide handler of functions.
# A function represent a command defined by the protocol

Packet = Struct.new(:id, :content)
Client = Struct.new(:name, :room, :socket)

class           Protocol

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

  def           name(src_id, clients, packets, data)
    exist = false
    if (data[1].chomp != "")
      cmd = data[1].split(/\.?\s+/, 2)
      clients.each_key do |key|
        exist = true if (clients[key][:name] == cmd[0])
      end
      if (exist == false)
        clients[src_id][:name] = cmd[0]
        packets << Packet.new(src_id, "name YES #{cmd[0]}")
      else
        packets << Packet.new(src_id, "name NO #{cmd[0]}")
      end
    else
      packets << Packet.new(src_id, "name EMPTY")
    end
    return packets, clients
  end

  def           bmsg(src_id, clients, packets, data)
    if (data[1].chomp != "")
      clients.each_key do |key|
        if (key != src_id)
          packets << Packet.new(key, "bmsg (#{clients[src_id][:name]}[public])>>: #{data[1]}")
        end
      end
      packets << Packet.new(src_id, "bmsg OK")
      return packets
    else
      packets << Packet.new(src_id, "bmsg EMPTY")
    end
    return packets
  end

  def           pmsg(src_id, clients, packets, data)
    if (data[1].chomp != "")
      cmd = data[1].split(/\.?\s+/, 2)
      if (cmd[1].chomp != "")
        clients.each_key do |key|
          if (key != src_id && clients[key][:name] == cmd[0])
            packets << Packet.new(key, "pmsg (#{clients[src_id][:name]}[private])>> #{cmd[1]}")
            break
          end
        end
        packets << Packet.new(src_id, "pmsg OK")
      else
        packets << Packet.new(src_id, "pmsg EMPTY")
      end
    else
      packets << Packet.new(src_id, "pmsg EMPTY")
    end
      return packets
  end
end
