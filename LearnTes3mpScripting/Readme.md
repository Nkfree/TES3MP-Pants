# A really basic guide on How to get into LUA for tes3mp's serverside Scripting
# and code a first game feature

Hey this wants to be a introduction for dudes tryin to
modify the their TES3MP Servers. LUA is pretty easy to
learn and you see on some public servers how massive
customizable Servers are with just modifying the Core-
scripts. It is pretty rewarding when you implement your
first own Game Feature within two days. And after a time
you get a basic understanding with which you will see
its only about what you can imagine from a Game Design
perspective to make an awesome tes3 Multiplayer Server.
I think tes3mp is a lot of fun and it does make even more
if you get some basic scripting knowledge to customize
all stuff. Maybe dudes get a basic look behind the games
they are playing and might even find interest in 
programming when they see how much is possible with this.
When you expect a professional introduction into this
stuff, this tutorial will disappoint you.
But for designing awesome game features for your own
tes3mp server you can come far with a basic knowledge.
So see this as encouragement for dudes that need a
little helping hand to start out with this.

## For dudes that know programming

You can skip this introduction since its focuses on
pretty basic stuff and instead follow this link.

[Click Here](https://github.com/Schnibbsel/TES3MP-Pants/blob/master/LearnTes3mpScripting/Readme.md)

i would be thankful if you write pull-requests to
this tutorial.

## How im gonna explain

You see my style of writing. I am no native speaker.
One year ago i knew some basic stuff of programming
and just learned how to figure out solutions in lua
with tes3mp. Neither am i an experienced programmer,
nor am i the best for writing this tutorial.
I am still gonna try to make it as understandable as
possible for dudes that never got in contact with
programming before. We gonna start out with learning
some programming basics as far as i know them and
gonna move on soonish to implementing our first
command as a neat game feature, making more out of it
and then moving it to a file. After that you will
have a basic knowledge that makes it easy to go
further from that point and find your way around in
lua. It shouldnt take too much of your time until
you are able to customize your server like you want to.

## Scripting basics

[you might want to skip this part and watch a youtube tutorial instead](https://www.youtube.com/watch?v=dHURyRLMOK0)
since its more professional than my knowledge

If you know what variables and functions are skip this part.
First we need to understand this basic behaviour:
```
a = 1
if a == 2 then
b = 3
elseif a == 3 then
b = 4
else
b = 5
end
print(b)
```
with programming you are telling the computer what to do.
computer are running with energy on or energy off.
lua is far away from that computer code.
instead we are telling the server what to do within the
limitations we got.
what you see abbove are basic variables and some if checks.
variables are those stuff you know from mathematics in school,
where a²+b³=c².. and you need to put real values into the formular
to know which one is the end result. scripting is even easier.
i just have a basic understanding of maths.

above we are defining the variable `a` and giving it a value `1`
`a = 1`
so whenever we call the variable a later on it will have the value 1.
variables in lua can contain some stuff..
numbers which are called for example `integers`
or a text whose variable type would be `string`
or a boolean value which is `true` or `false`
like a yes or no.
so to get back to that codeblock above we are saying the computer
that variable a contains the value 1.
after that we tell that if that variable `a` equals `2` then
we want to set variable b to 3.
well is it? no its not we just set it `1` above.. so the computer 
will just skip that part and move on to the elseif. 
it checks if a equals 3 what is wrong also. so it doesnt execute the
following line and looks at `else`.. the if conditions before been wrong
so we tell him `if that stuff is right then do this else do b = 5`
this chain of if checks needs and end in lua to close it.
after that we use a command lua provides to print the value of b to the screen.
so this code block would print `5` to the screen.

this could be a code block we put into the tes3mp CoreScripts if we
would want the the sever terminal to print us `5` into it.
this should be pretty easy stuff if you ever saw programming code before,
the only difference is how our scripting lanuage lua wants those if conditions to
look like. You always need to wrtite `if X then Y end`. you can put a elseif or 
just only a else between if you need but lua needs to understand the code you
write down to know what you want from him.
so you are not able to write `can you tell me what is b?`
you need to stick to the commands lua understands to tell the computer what
to do.

so we understand what variables are, we understand that while scripting we
are telling the server what to do with sticking to the provided lua language,
and we got a basic knowledge of how we would do a check.
only thing you now would need to understand is what a function is.
we take an example. while we are playing tes3mp and see dudes are changing
places (which are devided into cells) and have different skills we want
to check on a dude from time to time to get a message wheneever
he changes to balmora (cell "-2, -3") and got a acrobatics skill
higher than 30. we could check that like
```
if cellDescription == "-2, -3" then
	if Players[pid].data.skills["Acrobatics"] > 30 then
		print("Jumping on houses is forbidden on this server")
	end
end
```
we are putting a second if check into the other two have two conditions
for the message we want to send. Our first variable is cellDescription
which contains the current players cell and we compare it with the value
"-2, -3". are those the same then the server moves on to the second if check
to look if the Players[pid].data.skills["Acrobatics"] variable is bigger 
than 30. We could also compare like >= 30 or < 30. If those conditions
are both fulfilled he will print a message to not jump on houses.
We could put this into the CoreScripts like this, but since we want this
codeblock to be in multiple places in the CoreScripts and dont want to
repeat that code everytime we put it into a function.
```
JumpingCheck = function(cellDescription, pid)
	if cellDescription == "-2, -3" then
		if Players[pid].data.skills["Acrobatics"] > 30 then
			print("Jumping on houses is forbidden on this server")
		end
	end
end
```
now we could call that codeblock whereever we want with
`JumpingCheck(cellDescription, pid)` to execute the code in it.
we are giving over the two variables we need to the function codeblock
so he can use them to check for our conditions and print that message if
they are both true.
the c++ side of things provides us with all kind of functions we
can call out of the lua CoreScripts.
print() would actually print the message to the server terminal window,
so we want it to be printed on the Ingame Chat we use:
`tes3mp.SendMessage(pid, message, SendToAll)`
while pid is the number of the player we know of from the /list command.
message is a string value we want to send.
and SendToAll is a boolean value with `true` or `false` wether we want
to let the message be seen from everybody or just from our player with the pid.
in the function that would look like
```
JumpingCheck = function(cellDescription, pid)
	if cellDescription == "-2, -3" then
		if Players[pid].data.skills["Acrobatics"] > 30 then
			message = "Jumping on houses is forbidden on this server"
			tes3mp.SendMessage(pid, message, false)
		end
	end
end
```
still we only put it into a function because we want to call it multiple
times in multiple places. we can put whereever we want
JumpingCheck(cellDescription, pid) to execute that codeblock.
now you could start with writing your own scripts, you will find a list
of the functions provided by tes3mp's C++ side at the end of this tutorial.
just stick to the formal needs of lua and read through the scripts to see
where which action is located and where you want your code to be executed.

## Scripting your first chat command into your tes3mp server

Before you move on take a google search for Notepad++ and install it.
Its an awesome text editor that recognizes lua code and automatically
highlights the interesting parts. except tes3mp itself we dont need
any other tools for our lua scripting, since starting a tes3mp server
gives you detailed bug reports where the mistakes in your code are located.

so what would be a neat feature to implement as a first command?
maybe we start with: we want to see which value the players on our server
have in merchantile to send them a message that they can get a reward
if they use a specific command. for this we need to take a short look into
tables. tables are the variable type lua provides to take more than one
variable. a good example is the Players table in the CoreScripts.
It gets defined in your mp-stuff/scripts/player/base.lua file and
you can generally imagine it like this.
```
Players = {} -- opens a table for this variable

Players[pid] = {} -- assigns a table to that key

Players[pid].data = { skills = {["Acrobatics"] = 13} } -- opens data and skills table
Players[pid].data.skills["Mercantile"] = 15 -- adds to skills table
-- puts a skills table with the skill value about
-- acrobatics and mercantile into the data sub table
-- this data table is what you see in your mp-stuff/data/player/ json files.
```
with this way we can store multiple variables into one table that we can use
like other variables. if you diddnt understand that variable type right away,
you will just understand it on the way.. just look up somewhere else in the scripts
how a check is done and use the table variable provided.
we can now move on to our command.
commands are located in mp-stuff/scripts/commandHandler.lua
take a look at that file. you will see a long elseif chain of all the commands
you know. with looking at their code you can see how they work.
but we want to put our own command in there like: 
```
elseif cmd[1] == "getmercantile" and moderator then
	for pd, pl in pairs(Players) do
		if pl.data.skills["Mercantile"] >= 14 then
			tes3mp.SendMessage(pd, "You my dude. have a good mercantile. use /getreward in chat\n", false)
			Players[pd].data.reward = true
		end
	end

elseif cmd[1] == "getreward" then
	if Players[pid].data.reward == true then
		inventoryHelper.addItem(Players[pid].data.inventory, "gold_001", 1000, -1, -1, "")
		Players[pid]:LoadInventory()
		Players[pid]:LoadEquipment()
		tes3mp.SendMessage(pid, "you got your reward. a 1000 gold.", false)
		Players[pid].data.reward = false
	else
		tes3mp.SendMessage(pid, "you are not allowed to get a reward, or you alrdy had one\n", false)
	end
```
so there is some new stuff in there. most important we are using a lua for loop to iterate
through all players. we want to execute the command for all players online, so we get
the table with pairs(Players) and assign the key of the table >pid< to our pd variable
and the content of that table position to the pl variable. the for loop does that for
every pid key he finds in that table. so for Players[0] .. Players[1].. Players[2] and so on.
this is a good way in doing something for every player in the game, so much you need to understand.
inside that for loop we can use the pd variable which got the current pid assigned to 
execute checks and commands for that specific player.
we check if the Mercantile skill is equal or above 14 and then just send him a message and
set a boolean variable to true, so we can check for that variable later on when that specific 
player uses the /getreward command.
if he passes the check, we use the provided inventoryHelper function to add gold 
to his inventory and then reload his inventory and his equipment.
we sure set that boolen variable to false then, to not let him execute that command multiple times.
when he next uses it, he wont pass the check for the reward variable and wont get 
no reward instead a message that he is not allowed to get one.

so this is much stuff to understand. the thing i can tell you is. you wont ever need to understand
everything if your goal is only making a neat server game design. later on for understanding rly
how SendMessage command works .. you would need to look into the c++ game code.
i dont know anything about c++. i just use the things the tes3mp developers provide us with.
i have seen people wanting to understand everything right out from the beginning,
but that only lead to them being overwhelmed and losing intrested because
it was too hard to accomplish a first good contribution or server script.
just look up how things are done and use them, its that easy and no magic at all.

now we want to see that command working. therefore we open commandHandler.lua with our
Notepad++ and find a place between two elseif commands and just put that codeblock over there.
we save the file and start our tes3mp-server.exe
if we made any mistakes it will print a message like 
"hey watch out you made a typo in line 222"
or 
"i dont know the variable reward... maybe you never defined it"
or
"dude you still need to close that if else block with an end or idk where to stop there"

maybe sometimes your server even crashes with a bug report. if it doesnt stay open then,
you need to start it out of the terminal window. Under windows you would click on start
type in cmd and the command prompt will be started. you type "cd mytes3mpfolder" to change
to the address of your tes3mp folder. and type in "tes3mp-server.exe"
and it runs that program in your cmd and will not close when errors occure.

when we got this all right. we got the command implemented. saved the file. ran tes3mp-server
we take a look at our mercantile, we alrdy set ourselfs to admins and type into chat
/getmercantile and see if it prints our message to the chat. then we use /getreward
and get our reward of 1000 gold. then we use /getreward again and see we dont get
another reward. Congratulations. your first game feature.
with other players online you will see you can get them a reward.


you are fully able now to understand the other script repositorys provided in the links
at the bottom of this page. just learn from them and see how they made stuff, and you will
find your way through all the stuff you need to know to start fully scripting.

## Outsourcing that command into a file and digging deeper into the CoreScripts

You might have seen in other scripts that they have own files they
just use to modify the CoreScripts. To do this, we create a text file and 
rename it to myCommand.lua , we right click and open it with Notepad++ and
write our two commands as functions in there and stick to the lua rules.
be sure you place your file in the folder mp-stuff/scripts/
your myCommand.lua file code should then look like this:
```
local myCommand = {}

myCommand.FuncyOne = function()
	for pd, pl in pairs(Players) do
		if pl.data.skills["Mercantile"] >= 14 then
			tes3mp.SendMessage(pd, "You my dude. have a good mercantile. use /getreward in chat\n", false)
			Players[pd].data.reward = true
		end
	end
end

myCommand.RogerTwo = function(pid)
	if Players[pid].data.reward == true then
		inventoryHelper.addItem(Players[pid].data.inventory, "gold_001", 1000, -1, -1, "")
		Players[pid]:LoadInventory()
		Players[pid]:LoadEquipment()
		tes3mp.SendMessage(pid, "you got your reward. a 1000 gold.", false)
		Players[pid].data.reward = false
	else
		tes3mp.SendMessage(pid, "you are not allowed to get a reward, or you alrdy had one\n", false)
	end
end

return myCommand
```
those names for the functions are actually just made up. they are your own you can
call them like you want. if you want to redistribute your scripts it would be cool
if others understand what you are talking about. Now we want commandHandler.lua to
know about this file. So we got at the top of commandHandler.lua and place there
`myCommand = require("myCommand")` so we can use the functions in there.
we now replace our code about the command in there with just:
```
elseif cmd[1] == "getmercantile" and moderator then
	myCommand.FuncyOne()

elseif cmd[1] == "getreward" then
	myCommand.RogerTwo(pid)
	
```
thats how we call those functions now in there. for the RogerTwo function we need
to give the pid variable over from commandHandler to that function, so we know
over there in our file in the specific function which dude wrote that command.

As last thing, we try to find our way around in the lua. you ask yourself..
now i want to make that specific game feature but its not command and idk
where to place it. its good to actually remember which features are alrdy 
made by the tes3mp scripters to look up if there is something similiar
and there you can look up how to do it and where to place it.
but generally you open serverCore.lua and you see the requires placed
on top and you scroll some meters down and you find all those functions
which are our server events. those events get triggered by the server
when something happens in the game client or server side.
for example OnActorDeath gets called when actors or players die and
provide you with the killer. you want to know more about this event?
you see it calls eventHandler.OnActorDeath and you open eventHandler.lua
and look that part up, what is happing there. on that way you can understand
the events we are provided with. those are also our limitations. we want
to make that neat stuff when a player hits a creature .. but we wont
be able to because we got no OnPlayerHit event yet. we just can do sth
in the OnPlayerKill event for example.
serverCore mostly links to stuff in eventHandler.lua where the events 
get handled and this one uses logicHandler.lua for the logic.
you might need to look up the three folders on top /player/,
/world/ and /cell/ to see their specific code. and you might
need inventoryHelper or even tableHelper functions in the /lib/
folder if you want to use them. you will learn the rest on your
way while creating neat game features.

## How to move on now

You plan out a game feature. You want something to happen. You try
to remember which published script does something similiar where
you could look up how its done. then you take a look at the serverCore
which event you could use. and take a look at eventHandler how its
handled there. this provides you with a much of information for your
specific need. 

you want to look up the published scripts over here, it got a list of
tes3mp script repositorys.
[TeamFOSS/Scripts](https://github.com/TES3MP-TeamFOSS/Scripts)


you want to look up the "tes3mp documentation" with the tes3mp c++ calls
[Documentation](https://tes3mpdoc.000webhostapp.com/)


most importantly join the tes3mp discord and just ask questions in 
#scripting_help

and just start out with your first script and look to improve it later on!
