# This class Provide handler of functions.
# A function represent a command defined by the protocol

Packet = Struct.new(:id, :content)

class           Protocol
  def initialize
    puts "handler command is now ready"
  end

  def           broadcast_message(parameter, client, packets)
    if (parameter.length == 2)
      puts "broadcast message is: #{parameter[1]}"
      packets << Packet.new(client.object_id.to_s, "toto42")
      return packets
    else
      puts "Usage: broadcast_message MESSAGE"
    end
  end
end
