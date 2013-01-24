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
    puts "\n********************"
  end

  def           nick(data, name)
    puts "********************"
    cmd = data[1].split(/\.?\s+/)
    if (cmd[0] == "YES")
      name = cmd[1].chomp
      puts "Your nick is now '#{cmd[1].chomp}' !"
    elsif (cmd[0] == "NO")
      puts "'#{cmd[1].chomp}' is not available !"
    elsif(cmd[0] == "EMPTY")
      puts "USAGE: nick USERNAME"
    end
    puts "********************"
    return (name)
  end

  def           broadcast_msg(data)

    cmd = data[1].split(/\.?\s+/)
    if (cmd[0] == "OK")
      return
    end
    if(cmd[0] == "EMPTY")
      puts "\nUSAGE: broadcast_msg MESSAGE"
    else
      puts "\n#{data[1]}"
    end
  end

  def           private_msg(data)
    cmd = data[1].split(/\.?\s+/)
    if (cmd[0] == "OK")
      return
    end
    if(cmd[0] == "EMPTY")
      puts "\nUSAGE: private_msg MESSAGE"
    else
      puts "\n#{data[1]}"
    end
  end

end
