# This class provide handler of functions.
# A function represent a command defined by the protocol

class           Protocol

  def initialize
    puts "handler command is now ready"
  end

  def           list(data)
    puts "\n********************"
    if (data[1] != "")
      cmd = data[1].split(/\.?\s+/)
      puts "List of online users"
      cmd.each do |name|
        puts name
      end
    else
      puts "No client online !"
    end
    puts "********************"
  end

  def           nick(data)
    puts "Nick function"
  end

  def           broadcast_msg(data)
    puts "broadcast message function"
  end

  def           private_msg(data)
    puts "private message function"
  end

end
