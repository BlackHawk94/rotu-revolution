/**
* vim: set ft=cpp:
* file: scripts\servers\_servername.gsc
*
* authors: Luk, 3aGl3, Bipo, Etheross
* team: SOG Modding
*
* project: RotU - Revolution
* website: http://survival-and-obliteration.com/
*
* Reign of the Undead - Revolution by Luk and 3aGl3
* You may modify this code to your liking or reuse it, as long as you give credit to those who wrote it
* Based on Reign of the Undead 2.1 created by Bipo and Etheross
*/


/***
*
* 	_servername.gsc
*	Changes placeholders in the servername with live-data
*
*/

init()
{
	if(!level.dvar["game_changing_hostname"] || getDvar("sv_newhostname") == "")
		return;
	
	wait 1;
	
	level.pihostname = getDvar("sv_newhostname");
	
	thread WatchHostname();
}

/*
Useable paramaters:

PIHN_VERSIONFULL		-	Version (incl. "RotU-Revolution")
PIHN_VERSIONSHORT		-	Version number only
PIHN_BUILD				-	Build number
PIHN_PLAYERS			-	Amount of Players
PIHN_SOLDIERS			-	Amount of Soldiers
PIHN_SPECIALISTS		-	Amount of Specialists
PIHN_ARMOREDS			-	Amount of Armoreds
PIHN_ENGINEERS			-	Amount of Engineers
PIHN_MEDICS				-	Amount of Medics
PIHN_MAXPLAYERS			-	Slots (without bots)
PIHN_ALIVEPLAYERS		-	Players alive
PIHN_DOWNEDPLAYERS		-	Players down
PIHN_ZOMBIESALIVE		-	Zombies alive
PIHN_WAVENUMBER			-	Wave Number
PIHN_WAVENAME			-	Name of wave
PIHN_WAVESIZE			-	Size of current wave
PIHN_WAVEKILLED			-	Amount of killed zombies in the current wave
PIHN_WAVELEFT			-	Amount of zombies left to end the wave
PIHN_BESTPLAYER			-	Best Player Name (Score)
PIHN_MOSTKILLSPLAYER	-	Most Kills Player name
PIHN_ZOMBIESALIVE		-	Living Zombie Count
*/

WatchHostname()
{
	level endon("game_ended");
	newhostname = undefined;

	while(1)
	{
		newhostname = GetNewHostname();
		if(isDefined(newhostname)){
			if(getDvar("sv_hostname") == newhostname){
				wait 0.1;
				continue;
			}

			setDvar("sv_hostname", newhostname);
		}
		wait level.dvar["game_changing_hostname_time"];
	}
}

GetNewHostname()
{
	string = level.pihostname;
	//iPrintln("Getting new hostname: " + string);
	string = CheckString("PIHN_VERSIONFULL", string);
	string = CheckString("PIHN_VERSIONSHORT", string);
	string = CheckString("PIHN_BUILD", string);
	string = CheckString("PIHN_PLAYERS", string);
	string = CheckString("PIHN_SOLDIERS", string);
	string = CheckString("PIHN_SPECIALISTS", string);
	string = CheckString("PIHN_ARMOREDS", string);
	string = CheckString("PIHN_ENGINEERS", string);
	string = CheckString("PIHN_MEDICS", string);
	string = CheckString("PIHN_MAXPLAYERS", string);
	string = CheckString("PIHN_ALIVEPLAYERS", string);
	string = CheckString("PIHN_DOWNEDPLAYERS", string);
	string = CheckString("PIHN_ZOMBIESALIVE", string);
	string = CheckString("PIHN_WAVENUMBER", string);
	string = CheckString("PIHN_WAVENAME", string);
	string = CheckString("PIHN_WAVESIZE", string);
	string = CheckString("PIHN_WAVEKILLED", string);
	string = CheckString("PIHN_WAVELEFT", string);
	string = CheckString("PIHN_BESTPLAYER", string);
	string = CheckString("PIHN_MOSTKILLSPLAYER", string);
	
	return string;
}

CheckString(search, string)
{
	if(!isDefined(search) || !isDefined(string))
		return;
	
	if(!isSubStr(string, search))
		return string;
	
	cont = false;
	mark = [];
	
	for(i = 0; i < string.size; i++)
	{
		if(string[i] != search[0])
			continue;
		
		mark[0] = i;
		for(ii = 0; ii < search.size; ii++)
		{
			if(search[ii] != string[i+ii])
			{
				cont = true;
				break;
			}
			mark[1] = int(i+ii)+1;
		}
		if(cont)		//we are not done yet
		{
			cont = false;
			continue;
		}
		break;
	}
	//iPrintln(GetSubStr(string, 0, mark[0]) + "TO_BE_REPLACED" + GetSubStr(string, mark[1], string.size));
	return getSubStr(string, 0, mark[0]) + ReplaceString(search) + GetSubStr(string, mark[1], string.size);
}

ReplaceString(replace)
{
	if(!isDefined(replace))
		return;
	
	switch(replace)
	{
		case "PIHN_VERSIONFULL":
			return level.rotuVersion_hostname;
		case "PIHN_VERSIONSHORT":
			return level.rotuVersion_hostname_short;
		case "PIHN_BUILD":
			return level.buildnumber;
		case "PIHN_PLAYERS":
			return level.activePlayers;
		case "PIHN_SOLDIERS":
			return level.classcount["soldier"];
		case "PIHN_SPECIALISTS":
			return level.classcount["specialist"];
		case "PIHN_ARMOREDS":
			return level.classcount["armored"];
		case "PIHN_ENGINEERS":
			return level.classcount["engineer"];
		case "PIHN_MEDICS":
			return level.classcount["medic"];
		case "PIHN_MAXPLAYERS":
			return (getDvarInt("bot_count") - getDvarInt("sv_maxClients"));
		case "PIHN_ALIVEPLAYERS":
			return level.alivePlayers;
		case "PIHN_DOWNEDPLAYERS":
			return level.activePlayers-level.alivePlayers;
		case "PIHN_WAVENUMBER":
			return level.currentWave;
		case "PIHN_WAVENAME":
			return waveName(level.currentType);
		case "PIHN_WAVESIZE":
			if(level.intermission) return "?";
			return level.waveSize;
		case "PIHN_WAVEKILLED":
			if(level.intermission) return "?";
			return level.waveProgress;
		case "PIHN_WAVELEFT":
			if(level.intermission) return "?";
			return level.waveSize-level.waveProgress;
		case "PIHN_BESTPLAYER":
			max = 0;
			best = undefined;
			for(i = 0; i < level.players.size; i++){
				p = level.players[i];
				if(p.isActive){
					if(p.score > max){
						max = p.score;
						best = p;
					}
				}
			}
			if(isDefined(best))
				return best.name;
			else
				return "none";
		case "PIHN_MOSTKILLSPLAYER":
			max = 0;
			best = undefined;
			for(i = 0; i<level.players.size; i++){
				p = level.players[i];
				if(p.isActive){
					if(p.kills > max){
						max = p.kills;
						best = p;
					}
				}
			}
			if(isDefined(best))
				return best.name;
			else
				return "none";
		case "PIHN_ZOMBIESALIVE":
			return level.botsAlive;
		case "default":
			return replace;
	}
}

waveName(name){
	if(level.intermission)	return "Intermission";
	switch(name){
		case "normal": return "Normal";
		case "dog": return "Dogs";
		case "burning": return "Inferno";
		case "helldog": return "Helldogs";
		case "toxic": return "Crawlers";
		case "tank": return "Hell";
		case "scary": return "Night";
		case "boss": return "Boss";
		case "grouped": return "Grouped";
		case "finale": return "FINALE";
		default: return "undefined";
	}
}