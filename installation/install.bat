@echo off
color 0a
cd ..
@echo on
echo Installing Basic Libraries...
haxelib install lime
haxelib install openfl 9.0.2
haxelib install flixel

@echo Setting Up Stuff...
haxelib run lime setup flixel
haxelib run lime setup

@echo Installing other shit
haxelib install flixel-tools
haxelib run flixel-tools setup

haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons

echo Removing Polymod in favor for MasterEric's polymod version...
haxelib remove polymod
haxelib git polymod https://github.com/MasterEric/polymod
echo haxelib git polymod https://github.com/larsiusprime/polymod.git
@echo Installing the last stuff
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc

haxelib install hscript
haxelib install newgrounds
pause