/**
* vim: set ft=cpp:
* file: scripts\players\_playermodels.gsc
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

init()
{
	precache();
}

precache()
{
//	precachemodel("body_mp_usmc_grenadier");		it doesn't look like this is used...
	
	precachemodel("body_mp_usmc_rifleman");
	precachemodel("body_mp_usmc_support");
	precachemodel("body_mp_usmc_woodland_sniper");
	precachemodel("body_mp_opforce_support");
	precachemodel("body_complete_mp_spetsnaz_vlad");
	precachemodel("body_mp_sas_urban_specops");
	precachemodel("body_mp_usmc_woodland_support");
	precachemodel("body_mp_usmc_woodland_recon");
	precachemodel("body_mp_usmc_woodland_specops");
	precachemodel("body_mp_usmc_sniper");
	
	precachemodel("head_sp_usmc_zach_zach_body_goggles");
	precachemodel("head_sp_usmc_sami_goggles_zach_body");
	precachemodel("head_mp_usmc_ghillie");
	precachemodel("head_sp_opforce_derik_body_f");
	precachemodel("head_sp_sas_woodland_mac");
	precachemodel("head_sp_opforce_geoff_headset_body_c");
	precachemodel("head_sp_sas_woodland_peter");
	precachemodel("head_sp_sas_woodland_todd");
	precachemodel("head_sp_sas_woodland_hugh");
	precachemodel("head_sp_spetsnaz_collins_vladbody");
}

setPlayerClassModel(class)
{
	self detachAll();
	self.myBody = "";
	self.myHead = "";
	

	
	switch (class) // Models for class
	{
		case "soldier":
			rI = randomint(2);
			switch (rI)
			{
				case 0:
					self.myBody = "body_mp_usmc_rifleman";
				break;
				case 1:
					self.myBody = "body_mp_usmc_support";
					rII = randomint(2);
					if (rII == 0)
						self.myHead = "head_sp_usmc_zach_zach_body_goggles";
					else
						self.myHead = "head_sp_usmc_sami_goggles_zach_body";
				break;
			}
		break;
		case "specialist":
			self.myBody = "body_mp_usmc_woodland_sniper";
			self.myHead = "head_mp_usmc_ghillie";
		break;
		case "armored":
			rI = randomint(2);
			switch (rI)
				{
					case 0:
						self.myBody = "body_mp_usmc_woodland_support";
						self.myHead = "head_sp_sas_woodland_mac";
					break;					
					case 1:
						self.myBody = "body_mp_usmc_woodland_support";
						self.myHead = "head_sp_opforce_derik_body_f";
					break;
				}
		break;
		case "engineer":
			rI = randomint(2);
			switch (rI)
			{
				case 0:
						self.myBody = "body_mp_sas_urban_specops";
				break;
				case 1:
						self.myBody = "body_complete_mp_spetsnaz_vlad";
				break;
			}
		break;
		// case "scout":
			// rI = randomint(2);
			// switch (rI)
			// {
				// case 0:
					// self.myBody = "body_mp_usmc_woodland_recon";
				// break;
				// case 1:
					// self.myBody = "body_mp_usmc_woodland_recon";
				// break;
			// }
				
			// rI = randomint(3);
			// switch (rI)
			// {
				// case 0:
					// self.myHead = "head_sp_opforce_geoff_headset_body_c";
				// break;
				// case 1:
					// self.myHead = "head_sp_sas_woodland_peter";
				// break;
				// case 2:
					// self.myHead = "head_sp_sas_woodland_todd";
				// break;
			// }


		// break;
		case "medic":
				self.myBody = "body_mp_usmc_sniper";
				
				rI = randomint(2);
				switch (rI)
				{
					case 0:
						self.myHead = "head_sp_sas_woodland_hugh";
					break;
					case 1:
						self.myHead = "head_sp_spetsnaz_collins_vladbody";
					break;

				}
		break;
	}
	// Setting the models
	if (self.myBody != "")
	self setmodel(self.myBody);
	if (self.myHead != "")
	self attach(self.myHead);
}	