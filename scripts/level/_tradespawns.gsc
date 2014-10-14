//
// ########   #######  ######## ##     ##         ########  ######## ##     ##  #######  ##       ##     ## ######## ####  #######  ##    ## 
// ##     ## ##     ##    ##    ##     ##         ##     ## ##       ##     ## ##     ## ##       ##     ##    ##     ##  ##     ## ###   ## 
// ##     ## ##     ##    ##    ##     ##         ##     ## ##       ##     ## ##     ## ##       ##     ##    ##     ##  ##     ## ####  ## 
// ########  ##     ##    ##    ##     ## ####### ########  ######   ##     ## ##     ## ##       ##     ##    ##     ##  ##     ## ## ## ## 
// ##   ##   ##     ##    ##    ##     ##         ##   ##   ##        ##   ##  ##     ## ##       ##     ##    ##     ##  ##     ## ##  #### 
// ##    ##  ##     ##    ##    ##     ##         ##    ##  ##         ## ##   ##     ## ##       ##     ##    ##     ##  ##     ## ##   ### 
// ##     ##  #######     ##     #######          ##     ## ########    ###     #######  ########  #######     ##    ####  #######  ##    ## 
//
// Reign of the Undead - Revolution ALPHA 0.7 by Luk and 3aGl3
// Code contains parts made by Luk, Bipo, Etheross, Brax, Viking, Rycoon and Activision (no shit)
// (Please keep in mind that I'm not the best coder and some stuff might be really dirty)
// If you consider yourself more skilled at coding and would enjoy further developing this, contact me and we could improve this mod even further! (Xfire: lukluk1992 or at http://puffyforum.com)
//
// You may modify this code to your liking (since I - Luk - learned scripting the same way)
// You may also reuse code you find here, as long as you give credit to those who wrote it (5 lines above)
//
// Based on Reign of the Undead 2.1 created by Bipo and Etheross
//
#include scripts\include\hud;

init(){
	precache();
}

precache(){
	precachemodel("com_vending_can_new1_lit"); // Equipment
	precachemodel("com_shopping_cart");	   // Weapon Upgrade
	
	level.tradespawnModels = [];
	level.tradespawnModels["upgrade"] = "com_shopping_cart";
	level.tradespawnModels["equipment"] = "com_vending_can_new1_lit";
}

buildTradespawns(){
	if( !isDefined( level.tradespawns ) )
		return;
	
	for( i = 0; i < level.tradespawns.size; i++ ){
	
		level.tradespawns[i].model = spawn("script_model", level.tradespawns[i].origin);
		level.tradespawns[i].model.angles = level.tradespawns[i].angles;
		
		if( i % 2 == 0 )
			level.tradespawns[i].model setModel(level.tradespawnModels["upgrade"]);
		else
			level.tradespawns[i].model setModel(level.tradespawnModels["equipment"]);
	}
	
	for( i = 0; i < level.tradespawns.size; i++ ){
		if( i % 2 == 0 )
			buildUsableShop(level.tradespawns[i].model, "upgrade", level.tradespawns[i].origin, level.tradespawns[i].angles);
		else
			buildUsableShop(level.tradespawns[i].model, "equipment", level.tradespawns[i].origin, level.tradespawns[i].angles);
	}
}

/*
	Builds interactable objects on the map where players can upgrade weapons or buy equipment
	Only used when the map does not have these and uses _tradespawns.gsc
*/
buildUsableShop(ent, type, origin, angles){

	switch( type ){
		case "upgrade":
			iprintlnbold("Spawning upgrade tradespawn!");
			level scripts\players\_usables::addUsable(ent, "ammobox", &"USE_UPGRADEWEAPON", 96);
			createTeamObjpoint(ent.origin+(0,0,72), "hud_weapons", 1);
			ent setContents(2);
			break;
			
		case "equipment":
			iprintlnbold("Spawning equipment tradespawn!");
			level scripts\players\_usables::addUsable(ent, "extras", &"USE_BUYUPGRADES", 96);
			createTeamObjpoint(ent.origin+(0,0,72), "hud_ammo", 1);
			ent setContents(2);
			break;
	}

}