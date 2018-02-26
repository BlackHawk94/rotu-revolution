/**
* vim: set ft=cpp:
* file: scripts\players\_claymore.gsc
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

#include scripts\include\useful;

init()
{	
	if(!isDefined(level.claymoreFXid))
		precache();
	level.claymoresEnabled = true;
	
	thread WatchForClaymore();
}

precache(){
	level.claymoreFXid = loadfx("misc/claymore_laser");
}

WatchForClaymore()
{
	self endon("disconnect");
	self endon("death");
	self endon("not_zombie_anymore");
	if(!isDefined(self.claymores))
		self.claymores = 0;
	while(1)
	{
		self waittill("grenade_fire", proj, weap);
		if(weap == "claymore_mp")
		{
			if(self.claymores >= level.dvar["game_max_claymores"]){
				self iprintlnbold("You can only put down " + level.dvar["game_max_claymores"] + " Claymores max.!");
				self setWeaponAmmoClip(self getCurrentWeapon(), self getWeaponAmmoClip(self getCurrentWeapon()) + 1);
				proj delete();
				continue;
			}
			proj.owner = self;
			proj thread WatchClaymore();
		}
	}
}

WatchClaymore()
{
	self endon("death");
	
	self waitTillNotMoving();
	
	wait 0.15;
	self.owner.claymores++;
	self.fx = spawnFx(level.claymoreFxId, self getTagOrigin("tag_fx"), anglesToForward(self GetTagAngles("tag_fx")), anglesToUp(self getTagAngles("tag_fx")));
	triggerFx(self.fx);
	self.trigger = spawn("trigger_radius", self.origin-(0,0,192), 0, 192, 320);
	self thread RemoveOn("disconnect", self.owner);
	
	while(1)
	{
		if(!isDefined(self.trigger)){
			logPrint("LUK_DEBUG;self.trigger undefined for claymore!\n");
			return;
		}
		
		self.trigger waittill("trigger", player);
		
		if(!isDefined(player)){
			logPrint("LUK_DEBUG;player undefined for triggered claymore!\n");
			return;
		}
		
		if(!isDefined(self.owner)){
			logPrint("LUK_DEBUG;self.owner undefined for triggered claymore!\n");
			return;
		}
		
		if(player.pers["team"] == self.owner.pers["team"])
			continue;
			
		if(player.isBot && player.type == "boss" && level.bossPhase == 1)
			continue;
			
		if(!level.claymoresEnabled)
			continue;
		
		self PlaySound("claymore_activated");
		wait 0.3;
		self.fx delete();
		self.trigger delete();
		self.owner.claymores--;
		assert(self.owner.claymores >= 0);
		self detonate();
	}
}

RemoveOn(till, owner)
{
	self endon("death");
	if(isDefined(owner))
		owner waittill(till);
		
	self.fx delete();
	self.trigger delete();
	self delete();
}