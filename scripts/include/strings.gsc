/**
* vim: set ft=cpp:
* file: scripts\include\strings.gsc
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
*	TODO: Add file description
*
*/

#include scripts\include\data;

toUpper(char){
	switch(char){
		case "a":
			return "A";
		case "b":
			return "B";
		case "c":
			return "C";
		case "d":
			return "D";
		case "e":
			return "E";
		case "f":
			return "F";
		case "g":
			return "G";
		case "h":
			return "H";
		case "i":
			return "I";
		case "j":
			return "J";
		case "k":
			return "K";
		case "l":
			return "L";
		case "m":
			return "M";
		case "n":
			return "N";
		case "o":
			return "O";
		case "p":
			return "P";
		case "q":
			return "Q";
		case "r":
			return "R";
		case "s":
			return "S";
		case "t":
			return "T";
		case "u":
			return "U";
		case "v":
			return "V";
		case "w":
			return "W";
		case "x":
			return "X";
		case "y":
			return "Y";
		case "z":
			return "Z";
		default:
			return char;	
	}
}

isHexadecimal(char)
{
	return isSubStr("0123456789abcdef", toLower(char));
}

/* Makes all letters capital in a sentence */
allToUpper(string){
	if(!isDefined(string) || string == "")
		return;
	returns = "";
	for(i = 0; i < string.size; i++)
		returns += toUpper(getSubStr(string, i, i + 1));
	return returns;
}

/* Gets a string and returns it as a vector in the format of (x,y,z) 
Strings come either as (x,y,z) or (xx,yy,zz) etc., we have to take care of this....*/
strToVec(string){

	vector = (0,0,0);
	stringArr = strTok(string, ","); // Split string by ","-characters, results in (x(xx)? | y(yy)? | z(zz?))
	x = atof(GetSubStr(stringArr[0], 1, stringArr[0].size)); // we have (x or (xx or (xxx now, so we need to cut from 0 (this is "(") until the end...
	y = atof(stringArr[1]);
	z = atof(GetSubStr(stringArr[2], 0, stringArr[2].size - 1)); // we have z) or zz) or zzz), so we need to cut from end-1 to end which cuts out ")"
	
	vector = (x,y,z);
	
	return vector;
}

appendToDvar(dvar, string){
	setDvar(dvar, getDvar(dvar) + string);
}

getFullClassName(){
	switch(self.class){
		case "soldier": return "Soldier";
		case "armored": return "Armored";
		case "specialist": return "Specialist";
		case "engineer": return "Engineer";
		case "medic": return "Medic";
		default: return "undefined";
	}
}


/* Returns the approximate required time to display a string on a client, increasing the display time for every 4 characters of a string */
getTimeForString(stringCount, min){
	if(!isDefined(min))
		min = 0;
	time = min;
	stringCount -= 4;
	while(stringCount > 0){
		stringCount -= 4;
		time += 0.4;
	}
	return time;
}