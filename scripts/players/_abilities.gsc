/**
* vim: set ft=cpp:
* file: scripts\players\_abilities.gsc
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

#include scripts\include\hud;
#include scripts\include\data;
#include scripts\include\useful;
#include scripts\include\physics;
#include scripts\include\weapons;
#include common_scripts\utility;

init()
{
	precache();
	loadAbilityStats();
	level.weapons["flash"] = "usp_silencer_mp"; // We change the actual Flash Grenade to the Monkey Bomb, so we can use it as "Special Grenade" with instant-throw
	level.armoredForcefields = [];
}

precache()
{
	level.heal_glow_body		= loadfx("misc/heal_glow_body");
	level.heal_glow_effect 		= loadfx("misc/heal_glow");
	level.healingEffect    		= loadfx("misc/healing");
	
	precacheModel("armored_forcefield");
	
	precacheShader("icon_medkit_placed");
	precacheShader("icon_ammobox_placed");
}

loadAbilityStats()
{
	
	loadAbilityStats_soldier();
	loadAbilityStats_specialist();
	loadAbilityStats_armored();
	loadAbilityStats_engineer();
	loadAbilityStats_medic();
	
}

loadAbilityStats_soldier(){
	
	// F-Special
	level.special["rampage"]["recharge_time"] = 50;
	level.special["rampage"]["duration"] = 15;
	
}

loadAbilityStats_specialist(){
	
	// TODO: Fill with stats
	
}

loadAbilityStats_armored(){
	
	// Throwable forcefield
	level.special["armoredforcefield"]["radius"] = 128;
	level.special["armoredforcefield"]["recharge_time"] = 180;
	level.special["armoredforcefield"]["duration"] = 30;
	level.special["armoredforcefield"]["damagereduction"] = 0.6;
	
	// F-Special
	level.special["invincible"]["recharge_time"] = 60;
	level.special["invincible"]["duration"] = 20;
	
}

loadAbilityStats_engineer(){
	
	// F-Special
	level.special["augmentation"]["recharge_time"] = 1;
	
	// Throwable Special
	level.special["ammo"]["recharge_time"] = 75;
	
}

loadAbilityStats_medic(){

	// F-Special
	level.special["aura"]["recharge_time"] = 60;
	level.special["aura"]["duration"] = 20;
	
	// Throwable Special
	level.special["medkit"]["recharge_time"] = 60;
	
}

stopActiveAbility()
{ // Makes sure to stop assassin/soldier/scout special when downed

	self playerFilmTweaksOff();
	self.trance = "";
	self.inTrance = false;
	self.visible = true;
	self setMoveSpeedScale(self.speed);
	self unSetPerk("specialty_rof");
	
	if (!self.hasFastReload)
		self unSetPerk("specialty_fastreload");
		
	if(self.hud_streak.alpha != 0) // Removes the Killing Spree Number on the Screen
		self.hud_streak.alpha = 0;

}

resetAbilities()
{
	self notify("reset_abilities");
	
	self.stealthMp = 1;
	self.maxhealth = 100;
	self.speed = 1;
	self.revivetime = level.dvar["surv_revivetime"];
	
	self clearPerks();
	
	if(isDefined(self.armored_hud))
		self.armored_hud destroy();
	
	self.canAssasinate = false;
	self.isHitman = false;
	self.focus = -1;
	self.knifeDamageMP = 1;
	self.weaponNoiseMP = 1;
	self.immune = false;
	self.transfusion = false;
	self.lastTransfusion = false;
	self.canCure = false;
	self.hasMedicine = false;
	self.canSearchBodies = false;
	self.explosiveExpert = false;
	self.heavyArmor = false;
	self.specialtyReload = false;
	self.hasFastReload = false;
	self.hasRadar = false;
	self.damageDoneMP = 1;
	self.infectionMP = 1;
	self.canZoom = true;
	self.medkitTime = 12;
	self.medkitHealing = 25;
	self.auraHealing = 35;
	
	if(!isDefined(self.specialRecharge))
		self.specialRecharge = 0;
		
	self.longerTurrets = false;
	self.reviveWill = false;
	self.toxicImmunity = false;
	self.accuracyOverwrite = 6;
	self.special["ability"] = "none";
	self.special["recharge_time"] = 60;
	self.special["duration"] = 10;
}


getDamageModifier(weapon, means, target, damage)
{
	if(weapon == "none" || weapon == "turret_mp")
		return 1;

	MP = 1.00;
	
	// weapon upgrade damage modifiers
	wpnlvl = 0;
	if(weapon == self.primary)
		wpnlvl = self.unlock["primary"];
	else if(weapon == self.secondary)
		wpnlvl = self.unlock["secondary"];
	else if(weapon == self.extra)
		wpnlvl = self.unlock["extra"];

	if(getDvar("surv_unlock" + wpnlvl + "_damagemulti") != "")
		MP += getDvarFloat("surv_unlock" + wpnlvl + "_damagemulti");

	return MP;
}

getAbilityAllowed(class, rank, type, ability)
{
	if (type == "PR")
	{
		if (ability == "AB1" && rank >= 5)
			return true;
			
		if (ability == "AB2" && rank >= 15)
			return true;
			
		if (ability == "AB3" && rank >= 25)
			return true;
	}
	if (type == "PS")
	{
		if (ability == "AB1")
			return true;
			
		if (ability == "AB2" && rank >= 10)
			return true;
			
		if (ability == "AB3" && rank >= 20)
			return true;
			
		if (ability == "AB4" && rank >= 30)
			return true;
	}
	if (type == "SC")
	{
		if (ability == "AB1" && rank >= 5)
			return true;
			
		if (ability == "AB2" && rank >= 10)
			return true;
			
		if (ability == "AB3" && rank >= 20)
			return true;
			
		if (ability == "AB4")
		{
			//return true;
		}
		if (ability == "AB5")
		{
			//return true;
		}
	}
	
	return false;
}

loadClassAbilities(class)
{
	self resetAbilities();
	
	self loadGeneralAbilities(class);
	
	rank = scripts\players\_classes::getClassRank(class) + 1;
	
	// General Stats
	
	// Primary Abilities
	if (getAbilityAllowed(class, rank, "PR", "AB1"))
		self loadAbility(class, "PR", "AB1");
	
	if (getAbilityAllowed(class, rank, "PR", "AB2"))
		self loadAbility(class, "PR", "AB2");
	
	if (getAbilityAllowed(class, rank, "PR", "AB3"))
		self loadAbility(class, "PR", "AB3");
	
	// Passive Abilities
	
	if (getAbilityAllowed(class, rank, "PS", "AB1"))
		self loadAbility(class, "PS", "AB1");
	
	if (getAbilityAllowed(class, rank, "PS", "AB2"))
		self loadAbility(class, "PS", "AB2");
	
	if (getAbilityAllowed(class, rank, "PS", "AB3"))
		self loadAbility(class, "PS", "AB3");
	
	if (getAbilityAllowed(class, rank, "PS", "AB4"))
		self loadAbility(class, "PS", "AB4");
	
	// Secondary Ability
	
	if (getAbilityAllowed(class, rank, "SC", self.secondaryAbility))
		self loadAbility(class, "SC", self.secondaryAbility);
}

loadGeneralAbilities(class)
{
	self setPerk("specialty_pistoldeath");
	
	switch (class)
	{
		case "soldier":
			self.maxhealth = 115;
		break;
		
		// TODO: Okay?
		case "specialist":
			self.maxhealth = 100;
			self setPerk("specialty_quieter");
			self.speed = 1.02;
		break;
		
		case "medic":
			self.maxhealth = 110;
		break;
		
		case "amored":
			self.maxhealth = 140;
			self.speed = 0.95;
		break;
	}
}

loadSpecialAbility(special)
{
	self.special["ability"] = special;
	
	if (isDefined(level.special[special]["recharge_time"]))
		self.special["recharge_time"] = level.special[special]["recharge_time"];
	
	if (isDefined(level.special[special]["duration"]))
		self.special["duration"] = level.special[special]["duration"];

	if(self.canUseSpecial)
		self setClientDvar("ui_specialtext", "^2Special Available");
	else
		self setClientDvar("ui_specialtext", "^1Special Recharging");
}

loadAbility(class, type, ability)
{
	switch (class)
	{
		case "soldier":
			loadSoldierAbility(type, ability);
		break;
		
		case "specialist":
			loadSpecialistAbility(type, ability);
		break;
		
		case "medic":
			loadMedicAbility(type, ability);
		break;
		
		case "armored":
			loadArmoredAbility(type, ability);
		break;
		
		case "engineer":
			loadEngineerAbility(type, ability);
		break;
	}

}

loadSoldierAbility(type, ability)
{
	switch (type)
	{
		case "PR":
			self thread SOLDIER_PRIMARY(ability);
		break;
		
		case "PS":
			self thread SOLDIER_PASSIVE(ability);
		break;
	}
}
///////////////
//	SOLDIER  //
///////////////

SOLDIER_PRIMARY(ability)
{
	switch (ability)
	{
		case "AB1":
			self setPerk("specialty_bulletpenetration");
			self setPerk("specialty_bulletdamage");
		break;
		
		case "AB2":
			self loadSpecialAbility("rampage");
		break;
		
		case "AB3":
		
		break;
	}
}

SOLDIER_PASSIVE(ability)
{
	switch (ability)
	{
		case "AB1":
			
		break;
		
		case "AB2":
			self.hasFastReload = true;
			self SetPerk("specialty_fastreload");
		break;
		
		case "AB3":
			self thread regenerate(1, 1);
		break;
		
		case "AB4":
			self.maxhealth += 5;
			self.immune = true;
			self.infectionMP = 0;
		break;
	}
}

loadSpecialistAbility(type, ability)
{
	switch (type)
	{
		case "PR":
			self thread SPECIALIST_PRIMARY(ability);
		break;
		
		case "PS":
			self thread SPECIALIST_PASSIVE(ability);
		break;
	}
}

//////////////////
//	SPECIALIST  //
//////////////////

SPECIALIST_PRIMARY(ability)
{
	switch (ability)
	{
		case "AB1":
			
		break;
		
		case "AB2":
			
		break;
		
		case "AB3":
			self thread quickEscape();
		break;
	}
}

SPECIALIST_PASSIVE(ability)
{
	switch (ability)
	{
		case "AB1":
			
		break;
		
		case "AB2":
			
		break;
		
		case "AB3":
			
		break;
		
		case "AB4":
			self.hasRadar = true;
		break;
	}
}

loadMedicAbility(type, ability)
{
	switch (type)
	{
		case "PR":
			self thread MEDIC_PRIMARY(ability);
		break;
		
		case "PS":
			self thread MEDIC_PASSIVE(ability);
		break;
	}
}

///////////////
//	MEDIC    //
///////////////

MEDIC_PRIMARY(ability)
{
	switch (ability)
	{
		case "AB1":
			self giveWeap("medic_mp");
			self setWeapAmmoClip("medic_mp", 0);
			self setActionSlot(3, "weapon", level.weaponKeyS2C["medic_mp"]); // Actionslot [5]
			self thread watchMedkits();
			self thread restoreMedkit(level.special["medkit"]["recharge_time"]);
			self thread restoreMedkit(level.special["medkit"]["recharge_time"]);
		break;
		
		case "AB2":
			
		break;
		
		case "AB3":
			self.transfusion = true;
		break;
	}
}

MEDIC_PASSIVE(ability)
{
	switch (ability)
	{
		case "AB1":
			self.revivetime -= 1.5;
		break;
		
		case "AB2":
			self.canCure = true;
			self.speed *= 1.10;
		break;
		
		case "AB3":
			self.reviveWill = true;
		break;
		
		case "AB4":
			
		break;
	}
}

loadArmoredAbility(type, ability)
{
	switch (type)
	{
		case "PR":
			self thread ARMORED_PRIMARY(ability);
		break;
		
		case "PS":
			self thread ARMORED_PASSIVE(ability);
		break;
	}
}

///////////////
//	ARMORED  //
///////////////

ARMORED_PRIMARY(ability)
{
	switch (ability)
	{
		case "AB1":
			self giveWeap( "forcefield_mp" );
			self setWeapAmmoClip( "forcefield_mp", 0 );
			self setActionSlot( 3, "weapon", level.weaponKeyS2C["forcefield_mp"] );
			self thread watchArmoredForcefield();
			self thread restoreArmoredForcefield(level.special["armoredforcefield"]["recharge_time"]);
			self thread restoreArmoredForcefield(level.special["armoredforcefield"]["recharge_time"]);
		break;
		
		case "AB2":
			self loadSpecialAbility("invincible");
		break;
		
		case "AB3":
			// self.heavyArmor = true;
			// self giveArmoredHud();
		break;
	}
}

ARMORED_PASSIVE(ability)
{
	switch (ability)
	{
		case "AB1":
			
		break;
		
		case "AB2":
			self setPerk("specialty_bulletaccuracy");
			
		break;
		
		case "AB3":
			
		break;
		
		case "AB4":
			self.damageDoneMP = .9;
			self.infectionMP = .65;
		break;
	}
}

loadEngineerAbility(type, ability)
{
	switch (type)
	{
		case "PR":
			self thread ENGINEER_PRIMARY(ability);
		break;
		
		case "PS":
			self thread ENGINEER_PASSIVE(ability);
		break;
	}
}

///////////////
//	ENGINEER //
///////////////

ENGINEER_PRIMARY(ability)
{
	switch (ability)
	{
		case "AB1":
			self giveWeap("supply_mp");
			self setWeapAmmoClip("supply_mp", 0);
			self setActionSlot(3, "weapon", level.weaponKeyS2C["supply_mp"]); // Actionslot [5]
			self.ammoboxTime = 15;
			self.ammoboxRestoration = 25;
			self thread watchAmmobox();
			self thread restoreAmmobox(level.special["ammo"]["recharge_time"]);
		break;
		
		case "AB2":
			self loadSpecialAbility("augmentation");
		break;
		
		case "AB3":
			self.longerTurrets = true;
		break;
	}
}

ENGINEER_PASSIVE(ability)
{
	switch (ability)
	{
		case "AB1":
			
		break;
		
		case "AB2":
			self.toxicImmunity = true;
		break;
		
		case "AB3":
		break;
		
		case "AB4":
			
		break;
	}
}

// Abilities
rechargeSpecial(delta)
{
	if (self.special["ability"] == "none" || self.inTrance || self.god || self hasPerk("specialty_rof") || delta < 0)
		return;
		
	if(self.canUseSpecial)
	{
		self.specialRecharge = 100;
		self setclientdvars("ui_specialtext", "^2Special Available");
		self setclientdvar("ui_specialrecharge", 1);
		self.persData.specialRecharge = self.specialRecharge;
		return;
	}
	
	self.specialRecharge += delta;
	
	if (self.specialRecharge > 100)
		self.specialRecharge = 100;
		
	if (self.specialRecharge == 100)
	{
		self.canUseSpecial = true;
		self setClientDvars("ui_specialtext", "^2Special Available");
	}
	
	self setClientDvar("ui_specialrecharge", self.specialRecharge / 100);
	self thread specialRechargeFeedback();
	self.persData.specialRecharge = self.specialRecharge;
}

giveArmoredHud()
{
	self.armored_hud = NewClientHudElem (self);
	self.armored_hud.horzalign = "fullscreen";
	self.armored_hud.vertalign = "fullscreen";
	self.armored_hud.sort = -3;
	self.armored_hud.alpha = 1;
	self.armored_hud setShader("overlay_armored", 640, 480);
}

watchArmoredForcefield()
{
	self endon("reset_abilities");
	self endon("downed");
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		self waittill("grenade_fire", shield, weaponName);
		if( weaponName == level.weaponKeyS2C["forcefield_mp"] )
		{
			shield.owner = self;
			shield thread beArmoredForcefield(level.special["armoredforcefield"]["duration"]);
			self thread restoreArmoredForcefield(level.special["armoredforcefield"]["recharge_time"]);
			// self playsound("take_medkit"); /* TODO: INSERT PROPER "DEPLOYING SHIELD" SOUND */
		}
	}
}

watchMedkits()
{
	self endon("reset_abilities");
	self endon("downed");
	self endon("death");
	self endon("disconnect");
	while (1)
	{
		self waittill ("grenade_fire", kit, weaponName);
		if(weaponName == level.weaponKeyS2C["medic_mp"])		// weaponName might be none
		{
			kit.owner = self;
			kit thread beMedkit(self.medkitTime, self.medkitHealing);
			self thread restoreMedkit(level.special["medkit"]["recharge_time"]);
			self playSound("take_medkit");
		}
	}
}

watchAmmobox()
{
	self endon("reset_abilities");
	self endon("downed");
	self endon("death");
	self endon("disconnect");
	while (1)
	{
		self waittill ("grenade_fire", kit, weaponName);
		if(weaponName == level.weaponKeyS2C["supply_mp"])
		{
			kit.owner = self;
			kit thread beAmmobox(self.ammoboxTime);
			self thread restoreAmmobox(level.special["ammo"]["recharge_time"]);
			self playSound("take_ammo");
		}
	}
}

restoreArmoredForcefield(time)
{
	self endon("reset_abilities");
	self endon("downed");
	self endon("death");
	self endon("disconnect");

	self addTimer(&"ZOMBIE_ARMOREDFORCEFIELD_IN", "", time);
	wait time;

	self setWeapAmmoClip( "forcefield_mp", self getWeapAmmoClip("forcefield_mp") + 1 );
}

restoreSmokeGrenade(time)
{
	self endon("reset_abilities");
	self endon("downed");
	self endon("death");
	self endon("disconnect");

	self addTimer(&"ZOMBIE_SMOKEGRENADE_IN", "", time);
	wait time;

	self setWeapAmmoClip("smoke_grenade_mp", self getWeapAmmoClip("smoke_grenade_mp") + 1);
}

restoreMedkit(time)
{
	self endon("reset_abilities");
	self endon("downed");
	self endon("death");
	self endon("disconnect");

	self addTimer(&"ZOMBIE_MEDKIT_IN", "", time);
	wait time;

	self setWeapAmmoClip("medic_mp", self getWeapAmmoClip("medic_mp") + 1);
}

restoreAmmobox(time)
{
	self endon("reset_abilities");
	self endon("downed");
	self endon("death");
	self endon("disconnect");

	self addTimer(&"ZOMBIE_AMMOBOX_IN", "", time);
	wait time;

	self setWeapAmmoClip("supply_mp", self getWeapAmmoClip("supply_mp") + 1);
}

restoreMonkey(time)
{
	self endon("reset_abilities");
	self endon("downed");
	self endon("death");
	self endon("disconnect");

	self addTimer(&"ZOMBIE_MONKEY_IN", "", time);
	wait time;

	// TODO: Why not just give one...?
	self takeWeapon("usp_silencer_mp");
	self giveWeapon("usp_silencer_mp");
}

restoreInvisibility(time)
{
	self endon("reset_abilities");
	// self endon("downed");
	self endon("death");
	self endon("disconnect");
	
	if(isDefined(self.invisibiltyTimer))
		self removeTimer(self.invisibiltyTimer);

	self.invisibiltyTimer = self addTimer(&"ZOMBIE_INVISIBILITY_IN", "", time);
}

beAmmobox(time)
{
	self endon("death");
	
	self waitTillNotMoving();
	
	if(!isDefined(self))
		return;
	
	self thread scripts\gamemodes\_hud::createHeadiconKits(self.origin + (0, 0, 15), "icon_ammobox_placed", 0.5); // 2D Icon above the ammobox
	self thread scripts\gamemodes\_hud::createRadarIcon("icon_ammobox_radar"); // Radar Icon
	
	wait 1;
	for (i = 0; i < time; i++)
	{
		if(!isDefined(self.owner))
			break;
		
		for (ii = 0; ii < level.players.size; ii++)
		{
			player = level.players[ii];
			
			if(!isReallyPlaying(player))
				continue;
			
			if (distance(self.origin, player.origin) < 120)
			{
				if (!player.isDown)
					self.owner thread restoreAmmoClip(player);
			}
		}
		wait 1;
	}
	self delete();
}

beMedkit(time, heal)
{
	self endon("death");
	
	self waitTillNotMoving();
	
	if(!isDefined(self)) return;
	
	self thread scripts\gamemodes\_hud::createHeadiconKits(self.origin + (0, 0, 15), "icon_medkit_placed", 0.5); // 2D Icon above the medkit
	self thread scripts\gamemodes\_hud::createRadarIcon("icon_medkit_radar"); // Radar Icon
	
	wait 1;
	for (i = 0; i < time; i++)
	{
		if(!isDefined(self.owner) || !isReallyPlaying(self.owner))
			break;
		
		for (ii = 0; ii < level.players.size; ii++)
		{
			player = level.players[ii];
			
			if(!isReallyPlaying(player))
				continue;
			
			if (distance(self.origin, player.origin) < 120)
			{
				if (player.health < player.maxhealth && !player.isDown)
					self.owner thread healPlayer(player, heal);
			}
		}
		wait 1;
	}
	self delete();
}

/* TODO: MODIFY TO BE USED WITHOUT A THROWABLE OBJECT */
beArmoredForcefield(duration)
{	
	self waitTillNotMoving();
	
	if(!isDefined(self))
		return;
		
	if(!isDefined(self.owner) || !isReallyPlaying(self.owner))
	{
		self delete();
		return;
	}
	
	targetDestination = self.origin;
	
	self hide();
	ff = spawn("script_model", targetDestination);
	ff.owner = self.owner;
	wait 0.05;
	ff setModel("armored_forcefield");
	ff notSolid();
	
	if(isDefined(self))
		self delete();
	
	level.armoredForcefields[level.armoredForcefields.size] = ff;
	
	wait duration;
	
	level.armoredForcefields = removeFromArray(level.armoredForcefields, ff);
	ff delete();
}

quickEscape() // When health gets below 25% we give ourselves a speedboost - for Specialist class
{
	self endon("reset_abilities");
	self endon("death");
	self endon("disconnect");
	self endon("downed");
	while(1)
	{
		self waittill("damage", idamage);
		if(idamage != 0)
		{
			if(self.health <= self.maxhealth / 4 && !self.inTrance)
			{
				self trance_quickescape();
				wait level.special_quickescape_intermission;
			}
		}
	}
}

trance_quickescape()
{
	// kill all previous threads
	self notify("end_trance");
	self endon("end_trance");

	self.trance = "quick_escape";
	self.inTrance = true;

	self setMoveSpeedScale(self.speed + 0.2);
	self.visible = false;
	self playerFilmTweaks(1, 0, .75, ".25 1 .5",  "25 1 .7", .20, 1.4, 1.25);
	
	self thread trance_quickescape_end();
	
	wait level.special_quickescape_duration;// 6 seconds
	
	self notify("end_trance");
}

trance_quickescape_end()
{
	self waittill("end_trance");
	self.inTrance = false;
	self.trance = "";
	self playerFilmTweaksOff();
	self.visible = true;
	self SetMoveSpeedScale(self.speed);
}

regenerate(health, interval, limit)
{
	self endon("reset_abilities");
	self endon("death");
	self endon("disconnect");
	self endon("downed");
	if (!isDefined(limit))
	{
		while (1)
		{
			if (self.health < self.maxhealth)
				self heal(health);
				
			wait interval;
		}
	}
	else
	{
		for (i = 0; i < limit; i++)
		{
			if (self.health < self.maxhealth)
				self heal(health);
				
			wait interval;
		}
	}
}

heal(x)
{
	self.health += x;
	if (self.health > self.maxhealth)
		self.health = self.maxhealth;
		
	self updateHealthHud(self.health / self.maxhealth);
}


dynamicAccuracy()
{
	// self.accuracyOverwrite = 6;
	self endon("reset_abilities");
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		self waittill("begin_firing");
		self thread accuracyChangeUp();
		
		self waittill("end_firing");
		self thread accuracyChangeDown();
	}
}

accuracyChangeUp()
{
	self endon("reset_abilities");
	self endon("death");
	self endon("disconnect");
	self endon("end_firing");
	while(isReallyPlaying(self) && isAlive(self))
	{
		self setSpreadOverride(self.accuracyOverwrite);
		self.accuracyOverwrite--;
		
		if(self.accuracyOverwrite < 1)
			self.accuracyOverwrite = 1;
			
		wait 0.4;
	}
}

accuracyChangeDown()
{
	self endon("reset_abilities");
	self endon("death");
	self endon("disconnect");
	self endon("begin_firing");
	while(isReallyPlaying(self) && isAlive(self))
	{
		self setSpreadOverride(self.accuracyOverwrite);
		self.accuracyOverwrite++;
		
		if(self.accuracyOverwrite == 6)
			break;
			
		wait 0.4;
	}
}

/*
* TODO: Monitor Special-Grenade button instead of USE
*/
watchSpecialAbility()
{
	self endon("disconnect");
	self endon("killed_player");
	self endon("join_spectator");
	self endon("death");
	self notify("watch_special");
	self endon("watch_special");
	
	wait 1;
	
	if (!isDefined(self.special["ability"]) || self.special["ability"] == "none")
		return;
	
	i = 0;
	/* Will trigger the special when holding the F button for 1 second */
	while(1)
	{
		if(!self.isDown && !self.isBusy && self useButtonPressed())
			i++;
		else
			i = 0;
			
		if(i >= 10)
		{
			self thread onSpecialAbility();
			i = 0;
		}
			
		wait 0.1;
	}
}

onSpecialAbility()
{
	if (!self.canUseSpecial)
	{
		return;
	}
	
	self notify("special_ability");
	
	switch (self.special["ability"])
	{
		// SOLDIER
		case "rampage":
			self doRampage(self.special["duration"]);
			iprintln(self.name + "^7 activated their ^1Rampage^7!");
			self resetSpecial();
		break;
		
		// ARMORED
		case "invincible":
			self doInvincible(self.special["duration"]);
			iprintln(self.name + "^7 has become ^3Invincible^7!");
			self resetSpecial();
		break;
		
		// ENGINEER
		case "augmentation":
			if (self doAugmentation())
			{
				iprintln(self.name + "^7 ^3augmented ^7their ^3Turrets^7!");
				self resetSpecial();
			}
		break;
	}
}

resetSpecial()
{
	self.canUseSpecial = false;
	self.specialRecharge = 0;
	self setClientDvars("ui_specialtext", "^1Special Recharging", "ui_specialrecharge", 0);
}

healPlayer(player, heal)
{
	if (player.health == player.maxhealth || !isDefined(heal))
	return;
	
	player.health += heal;
	healed = heal;
	
	if (player.health > player.maxhealth)
	{
		healed -= player.health - player.maxhealth;
		player.health = player.maxhealth;	
	}
	
	player thread screenFlash((0, 0.65, 0), 0.5, 0.4);
	player thread healthFeedback();
	player updateHealthHud(player.health / player.maxhealth);
	
	if (player != self)
	{
		self scripts\players\_players::incUpgradePoints(getRewardForHeal(healed) * level.dvar["game_rewardscale"]);
		self.stats["healsGiven"] += healed;
	}
	
	if (self.curClass == "medic" && player != self)
	{
		self rechargeSpecial(healed / 4);
	}
	
	return healed;
}

restoreAmmoClip(player)
{
	wep = player getCurrentWeap();//gets the name of the current weapon of the player holding
	
	if (!scripts\players\_weapons::canRestoreAmmo(wep))//if it's a special weapon, it won't restore it's ammo E.g = raygun,tesla...
		return;
	
	stockAmmo = player getWeapAmmoStock(wep);//gets the total ammount of ammo it has at the moment, not the clip but the stock like 95
	stockMax = weapMaxAmmo(wep);//gets the total ammount of ammo the certain weapon has (not clip) E.g = MaxAmmo of ak47 is 180
	
	tenthOfMax = int(stockMax / 10);//E.g AK47= 180/10 = 18, 18 is an int so no need to round the number(17.5>18)
	
	if (tenthOfMax < 1)
		tenthOfMax = 1;

	perc = (stockMax - stockAmmo) / tenthOfMax;

	if (perc > 1)
		perc = 1;

	if(stockAmmo < stockMax)
	{
		if( (stockAmmo + tenthOfMax) > stockMax )
			tenthOfMax = stockMax - stockAmmo;
		
		stockAmmo += tenthOfMax;
		if( stockAmmo > stockMax )
			stockAmmo = stockMax;
		
		player setWeapAmmoStock(wep, stockAmmo);
		player thread screenFlash((0, 0, 0.65), 0.5, 0.4);
		player playLocalSound("weap_pickup");
		
		if (player != self && self.curClass == "engineer")
		{
			self scripts\players\_players::incUpgradePoints(int(2 * perc) * level.dvar["game_rewardscale"]);
			self.stats["ammoGiven"] += tenthOfMax;
			self scripts\players\_abilities::rechargeSpecial(8 * perc);
		}	
	}
}

getRewardForHeal(heal)
{
	if (heal > 0)
		return int((heal + 10) / 5);
	else
		return 0;
}

//*****************************************************************************************
// 										 Moving glow ball
//*****************************************************************************************

glow_heal_ball_out(p)
{
	offset = (0,0,40);
	ball_tag = spawn("script_model", self.origin + offset);
	ball_tag setModel("tag_origin");
	while(1)
	{
		wait 0.05;
		// check if the player is still defined or disconnected
		if(!isDefined(p))
		{
			// the player disconnected, end this
			ball_tag delete();
			break;
		}
		
		// get the players head origin
		head_tag_org = p getTagOrigin("j_head");
		if(distance(ball_tag.origin,head_tag_org) > 30)
		{
			// we are still away from the player, let's move to him
			movespeed = 1.3;
			num = 10;
			if(distance(ball_tag.origin,head_tag_org) < 64)
			{
				// we are pretty close, move faster (movespeed ist actually the movetime)
				movespeed = 0.55;
				num = 5;
			}
			
			ball_tag moveTo(head_tag_org, movespeed);
			for(i = 0; i < num; i++)
			{
				// play the effect the desired amount and at the same time wait
				playFXOnTag(level.heal_glow_effect, ball_tag, "tag_origin");
				wait 0.1;
			}
		}
		else
		{
			// we are close to the player, now heal him
			p thread player_glow_up();
			p notify("glow_ball_reached");
			ball_tag delete();
			break;
		}
	}
}

player_glow_up()
{
	tag = "j_head";
	playFXOnTag(level.heal_glow_body, self,tag);
}


//*****************************************************************************************
// 										 Rampage Special
//*****************************************************************************************

doRampage(time)
{
	self endon("death");
	self endon("downed");
	self endon("disconnect");
	
	self setClientDvar("ui_specialtext", "^5Special Activated!");
	self.canUseSpecial = false;
	
	self setPerk("specialty_rof");
	self setPerk("specialty_fastreload");
	
	self thread screenFlash((0.65, 0.1, 0.1), 0.5, 0.6);
	self playerFilmTweaks(1, 0, 0, "1 0 0",  "1 0 2", 0, 1, 1.2);//1, 0, .8, "0.9 0.4 0.3",  "1 0.5 0.5", .25, 1.4, 1.2
	self thread regenerate(2, time / 40, 40);

	wait time;

	self playerFilmTweaksOff();
	self thread screenFlash((0.65, 0.1, 0.1), 0.5, 0.6);
	self unSetPerk("specialty_rof");
	
	if (!self.hasFastReload)
		self unSetPerk("specialty_fastreload");
}

//*****************************************************************************************
// 										 Invincible Special
//*****************************************************************************************

doInvincible(time)
{
	self endon("death");
	self endon("downed");
	self endon("disconnect");
	
	self setClientDvar("ui_specialtext", "^5Special Activated!");
	self.canUseSpecial = false;
	self.god = true;
	self.immune = true;
	self.infectionMP = 0;
	self thread doInvincibleHud();
	self thread screenFlash((0.1, 0.1, 0.65), 0.5, 0.6);
	// self playerFilmTweaks(1, 0, 0, "0 0 1",  "0 1 1", 0, 0.9, 1);//1, 0, .4, "0.4 0.4 0.8",  "0.5 0.5 1", .25, 1.4, 1
	
	wait time;
	self.god = false;
	self.immune = false;
	self notify("stop_armored_hud");
	self updateArmorHud();
	self.infectionMP = 1;
	self playerFilmTweaksOff();
	self thread screenFlash((0.1, 0.1, 0.65), 0.5, 0.6);
}

doInvincibleHud()
{
	self endon("death");
	self endon("downed");
	self endon("disconnect");
	self endon("stop_armored_hud");
	
	if(!isDefined(self.armored_hud))
		self giveArmoredHud();
		
	self.armored_hud.color = (0.6, 0.6, 1);
	self.armored_hud.alpha = 1;
	
	while(1)
	{
		self.armored_hud fadeOverTime(0.3);
		self.armored_hud.alpha = 0;
		wait 0.3;
		
		self.armored_hud fadeOverTime(0.5);
		self.armored_hud.alpha = 1;
		wait 0.5;
	}
}

//*****************************************************************************************
// 									Augmented Turrets
//*****************************************************************************************

doAugmentation()
{
	if(level.turretsDisabled)
	{
		self iprintlnbold("Turrets are disabled! You can't use your Special!");
		return false;
	}
	
	turrets = [];
	for(i = 0; i < self.useObjects.size; i++)
	{
		o = self.useObjects[i];
		if(o.type == "turret" && o.owner == self && !o.occupied)
			turrets[turrets.size] = o;
	}
	
	if(turrets.size == 0)
	{
		self iprintlnbold("You need at least one turret to activate your Special!");
		return false;
	}
	
	for(i = 0; i < turrets.size; i++)
		turrets[i] scripts\players\_turrets::goAugmented();
		
	return true;
}