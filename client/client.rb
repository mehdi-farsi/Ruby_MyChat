require 'Classes/ClientNetwork'

def main
  n = ClientNetwork.new('localhost', 4242)
  n.main_loop
end

main
