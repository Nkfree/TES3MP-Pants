# Morrowind Splitscreen Guide

*Note: this Guide is for a tes3mp version that is not yet existent.*

**With these little steps you can play tes3mp in split screen mode on one computer.**

*This Guide was written for Windows*

You need:

* a Xbox360 Controller (feel free to test with others)
* the tes3mp version with "disable controller" support
* [Autohotkey Utility](https://www.autohotkey.com/)
* [the script above](https://github.com/Schnibbsel/TES3MP-Pants/blob/master/MorrowindSplitscreen/Splitscreen.ahk)

Just follow the steps until the end of this paper

* plug in your gamepad (and maybe try it one time in openmw)
* in openmw-launcher enable windowed mode under graphic settings
* Start two instances of the game just by starting tes3mp.exe tabbing out and starting it again
* log in with 2 different accounts
* resize the windows to fit your needs
* for your controller to work in both windows you need to Alt+Tab around a little
* my method is: open the controller game. Press Windows Button. Click on Taskbar. Alt+Tab into the other game instance
* you see the active window got other colors. try around a little
* most times when the window is any how inactive (not in focus) and still takes the controller input then you can tab into the other game
* as soon as you can control both windows with the controller at the same time move on with this guide
* now you could open the Menu with Esc in the active window head over to Controls and click "disable controller" button
* and you would be able to move one game with your keyboard+mouse and the inactive one with the gamepad

*but we still got some problems...*


### Problems with Cursor

While running around works flawlessly, the cursor for example in the character menu can make strange issues..

For example the mouse-player can move the cursor for the joypad-player

when then accidentaly clicking a button will make the gamepad-window active

forcing you to repeat the tabbing around procedure

**follow the following steps to find a work around:**

* download [Autohotkey Utility](https://www.autohotkey.com/) and install it
* download [this script](https://github.com/Schnibbsel/TES3MP-Pants/blob/master/MorrowindSplitscreen/Splitscreen.ahk) for Autohotkey and place it in your Documents folder
* This will automatically choose a window and dont send the clicks to the other window
* double click the script to start it. you will see it in the down right corner
* press k to enable or disable remapping mouse buttons into an openmw window
* press j to kill the script process and end it
* watch your game screens and choose the one which should be gamepad-controlled
* tabbing around again
* disabling controls in the other window
* now you should be unable to accidentaly click in the other window. to try press right mouse button a few times after pressing k

### Known Bugs

The cursor can still get invisible, stuck or lost. Most of the times just reopening the inventory/menu will enable the mouse cursor again in your window

It still is recommended to not open both the inventory at the same time

A lot of times you can skip out of Menus (or for example journal) when pressing the start button on your Xbox Controller

*GLHF if you find other bugs or feedback feel free to report*
