require 'Classes/Network'

def main
  n = Network.new(4242)
  puts "***    Server MyChat 1.0     ***"
  puts "*** developed by mehdi-farsi ***"
  n.main_loop
end

main
