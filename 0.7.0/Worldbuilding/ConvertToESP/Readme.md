# Text 2 ESP

With this lua script, you can convert your placed Objects in a cell into a text file that can be used by text2esp4 tool to generate a ESP.

Requires: txt2esp4

## Placing Objects

You can sure just convert objects you placed with your inventory.
But there are some ways to design complete Cells..
For example use [kanaFurniture](https://github.com/Atkana/tes3mp-scripts/blob/master/kanaFurniture.lua) or use the [placeAtPc console commands](https://en.uesp.net/wiki/Morrowind:Console)

## How to

Install everything

Design the cell

Relog so cellData gets saved

go into the cell you want to copy

use the /txt2esp command in chat to write the text file to mp-stuff/data/ folder

this will copy the objects you placed into a text file which txt2esp4 tool can read

open your CMD (maybe in WindowsXPMode)

use the txt2esp4 tool to generate the esp

for example:
```
txt2esp4 "txt2esp-Balmora, Guild of Fighters.esp" "fighters.esp" "Balmora, Guild of Fighters"
txt2esp <txtfile> <espfile> <cellName>
```

## Installation

Requires [txt2esp4](http://mw.modhistory.com/download-95-5272) tool

1. The tool maybe only runs on [Windows XP Mode](https://www.microsoft.com/en-us/download/details.aspx?id=8002)

2. Copy the lua file into your mp-stuff/scripts/ folder

3. Place `txt2esp = require("txt2esp")` on top of serverCore.lua

4. Place the following in CommandHandler.lua's Command elseif Chain

```
if cmd[1]== "txt2esp" then
	txt2esp.create(pid)
```

5. Go into a Cell and use the command to generate the text file which you can then be converted with txt2esp4 in windows XP Mode