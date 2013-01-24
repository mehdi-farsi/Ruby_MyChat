My Chat
===========

Client/Server app implemented in Ruby.
It implements an ASCII communication protocol.

##Required:##

Installation of [Ruby](http://www.ruby-lang.org/en/downloads).

##Usage:##

###Client###

In directory ```Ruby_MyChat/client```:

```ruby main.rb```

###Server###

In directory ```Ruby_MyChat/server```:

```ruby main.rb```

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

####Command 'bmsg'####

Send a message to a specific user.

Usage:

```
(guest1)>> pmsg USER YOUR_MESSAGE
```


******
###Thanks a lot for your passage on my page.###

BTW, you can find me on my LinkedIn [Profile](http://cn.linkedin.com/pub/mehdi-farsi/48/ba9/336/en).
******