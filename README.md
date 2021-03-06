My Chat
===========

Client/Server app implemented in Ruby.
It implements an ASCII communication protocol.

##Required:##

Installation of [Ruby](http://www.ruby-lang.org/en/downloads).

##Usage:##


###Client:###

In directory ```Ruby_MyChat/client```:

```ruby client.rb```

###Server:###

In directory ```Ruby_MyChat/server```:

```ruby server.rb```

###Commands:###

####Command 'list'####

Get list of online users.

Usage:

```
(guest1)>> list

List of online users
guest2
guest3
guest4

(guest1)>> 
```

####Command 'name'####

Allow to customize his nickname. The server send you a notification if the nickname already exist.

Usage:

```
(guest1)>> name kobe
Your nickname is now 'kobe' !
(kobe)>> 
```

####Command 'bmsg'####

Broadcast message to all clients.

Usage:

```
(guest1)>> bmsg YOUR_MESSAGE
```

####Command 'pmsg'####

Send a message to a specific user.

Usage:

```
(guest1)>> pmsg USER YOUR_MESSAGE
```

##Specifics:##

####Server:####

- Synchronous I/O multiplexing (select).
- Treatment of brutal disconnections of clients and server.
- Logs are displayed with a color system:
  - Blue  => new client.
  - Red   => client disconnected.
  - Green => packet sent.

####Client:####

- Synchronous I/O multiplexing (select).
- Displaying of a prompt.
- Real-time displaying with ```STDOUT.sync```.

##Under development:##

- System of room (similar to IRC).
- Command 'quit'.

 
 
******
###Thanks a lot for your passage on my page.###

BTW, you can find me on my LinkedIn [Profile](http://cn.linkedin.com/pub/mehdi-farsi/48/ba9/336/en).
******