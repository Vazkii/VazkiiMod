// ORIGINAL FUNCTIONS ================================================================================
var powerlevelOrig = undefined;
var displayCornerMessageOrig = undefined;
var balljunkOrig = undefined;
var playerhurtOrig = undefined;
var trixxOrig = undefined;
var itemzzOrig = undefined;
var giveitOrig = undefined;

// VARIABLES =========================================================================================
var customDescriptions = Array(); // An array of all our custom item descriptions
var pickedUpID = -1; // The ID of the last item picked up
var alwaysPolaroid = false; // Should the polaroid always be counted as equipped? Used to allow entrance to the chest without it
var takingDamage = false; // Is the player taking damage?
var refreshing = false; // Will the next item pool call be a pool refresh?
var messedWithItempools = false; // Have we made our modifications to the item pools yet?

// OVERRIDES =========================================================================================

function powerlevel() { // Function called when an item is picked up
	pickedUpID = _level0.a.highs.it; // Keep the ID of the item we just picked up
	powerLevelOrig();
	pickedUpID = -1; // Function done, discard this so it doesn't end up being used in the future
}

function displayCornerMessage(msg) { // Function called for displaying the item description in the corner
	var newmsg = msg;
	if(pickedUpID != -1 && customDescriptions[pickedUpID] != undefined) { // If we picked up an item recently
		newmsg = customDescriptions[pickedUpID]; // If we have a custom description, put it in
	}

	displayCornerMessageOrig(newmsg); // Call the original function after our changes to the message have passsed
}

function firr(trg) { // Function called for calculating tear rate, completely overriden as code needs to be inserted in the middle
	var v3 = _level0.a.ups[6] * 1.5 + (_level0.a.ups[32] + _level0.a.ups[80] + _level0.a.ups[1] + _level0.a.ups[120]) * 0.7 + (_level0.a.ups[196] + _level0.a.ups[59] - _level0.a.ups[182]) * 0.4 + (_level0.a.ups[101] + _level0.a.ups[90] + _level0.a.ups[189]) * 0.2;
	
	// Add tear rate for Tootpicks and Magic Mushroom
	v3 += _level0.a.ups[183] * 0.3 + _level0.a.ups[12] * 0.2;

	if (_level0.a.ups[120]) {
	  ++v3;
	}

// This code here made Eve have lower fire rate. NOT ANY MORE!
//	if (_level0.a.skiner == 6) {
//	  v3 -= 0.25;
//	}

	f1 = Math.sqrt(Math.max(0, 1 + v3 * 1.3));
	_level0.a.trg.fire = Math.max(5, 16 - f1 * 6 - Math.min(v3, 0) * 6);
	if (_level0.a.ups[69]) {
	  _level0.a.trg.fire *= 0.8;
	}
	if (_level0.a.ups[2]) {
	  _level0.a.trg.fire *= 2.1;
	  _level0.a.trg.fire += 3;
	}
	if (_level0.a.trixx(39)) {
	  _level0.a.trg.fire -= 2;
	}
	if (_level0.a.trg == _level0.a.player) {
	  _level0.a.firra = _level0.a.trg.fire;
	}
}

function balljunk() { // This checks if the player has the polaroid before opening up the chest, overriding it so it's not needed
	alwaysPolaroid = true; // Force the polaroid to be counted as equipped
	balljunkOrig();
	alwaysPolaroid = false; // Force it back so you get get actual "Permanent Polaroid Invincibility" ;)
}

function playerhurt(f1, f2, f3) { // Called when the player is hurt, just to prevent the player from always having polaroid
	takingDamage = true;
	playerhurtOrig(f1, f2, f3);
	takingDamage = false;
}

function trixx(id) { // Checks if the player has a trinket. Overriding so it allows for entering the chest without the polaroid
	return (id == 47 && alwaysPolaroid && !takingDamage) || trixxOrig(id);
}

function itemzz() { // Called when the Item Pools are filled, overrided to change them around
	itemzzOrig();
	if(refreshing) {
		messWithPools(); // The Item Pool was refreshed, let's mess with it again
	}
	refreshing = true;
}

function giveit() { // Called when an item is generated
	if(!messedWithItempools) {
		messWithPools();
	}
	
	return giveitOrig();
}

// FUNCTIONS =========================================================================================

function messWithPools() { // Called to change items around in the item pools
	var regularPool = _level0.ittt; // Let's keep the pool names somewhat sane
	var bossPool = _level0.ittt2;
	var secretRoomPool = _level0.ittt3;
	var shopPool = _level0.ittt4;
	var goldenChestPool = _level0.ittt6;
	var devilRoomPool = _level0.ittt7;
	var arenaPool = _level0.ittt8;
	var libraryPool = _level0.ittt9;
	var godRoomPool = _level0.ittt10;

	poolRemove(shopPool, 147); // Move Notched Axe from the Shop Pool to the Regular Pool
	regularPool.push(147);
	
	poolRemove(bossPool, 198); // Move the Box from the Boss Pool to the Shop Pool twice
	shopPool.push(198, 198);
	
	if(_level0.locker[62] && random(5) == 0) { // If Forget Me Now is unlocked, add it to the Shop Pool
		shopPool.push(127);
	}
	
	if(_level0.locker[75]) { // If Dad's Key is unlocked, move it from the Secret Room pool to the Regular Pool
		poolRemove(shopPool, 175);
		regularPool.push(175);
	}
	
	poolRemove(regularPool, 6); // Move Number One to the Secret Room Pool
	secretRoomPool.push(6);
	
	if(_level0.locker[38] && _level0.skiner != 0 && _level0.chala == 0 && random(4) == 0) { // If the D6 is unlocked, the player isn't playing as Isaac and not playing a challenge try adding D6 to the Devil Pool
		devilRoomPool.push(105);
	} else if(_level0.locker[65] && random(3) == 0) { // If the D6 wasn't in the Devil Pool and the D20 is unlocked, try adding it to the Devil Pool
		devilRoomPool.push(166);
	}
	
	messedWithItempools = true;
}

function poolRemove(pool, id) { // Remove an item from a pool
	var index = indexOf(pool, id); // Where is the item in the array?
	if(index != -1) {
		pool.splice(index, 1); // Remove the item from the pool array
	}
	
	index = indexOf(pool, id); // Recursively check through until the item is no longer present in the pool at all
	if(index != -1) {
		poolRemove(pool, id);
	}
}


function indexOf(array, val) { // This doesn't exist in ActionScript 2 for God knows what reason, just a workaround
	var i;
	for(i = 0; i < array.length; i++) {
		if(array[i] == val) {
			return i;
		}
	}
	return -1;
}

// INIT ==============================================================================================

this.onEnterFrame = function() { // Called for init
	if (_level0.a != undefined && !_level0.a.vazhooked) { // vazhooked used so it only calls once
		init();
		_level0.a.vazhooked = true; // Make sure this doesn't get called again
	}
}

function init() { // Initialize
	overrideFunctions();
	setupCustomDescriptions();
}

function overrideFunctions() { // Overrides the functions in vanilla isaac with ours
	powerLevelOrig = _level0.a.powerlevel; // Keep the original function for calling later 
	_level0.a.powerlevel = powerlevel; // Override the function with ours
	
	displayCornerMessageOrig = _level0.a.st22;
	_level0.a.st22 = displayCornerMessage;
	
	playerhurtOrig = _level0.a.playerhurt;
	_level0.a.playerhurt = playerhurt;
	
	balljunkOrig = _level0.a.balljunk;
	_level0.a.balljunk = balljunk;
	
	trixxOrig = _level0.a.trixx;
	_level0.a.trixx = trixx;
	
	itemzzOrig = _level0.a.itemzz;
	_level0.a.itemzz = itemzz;
	
	giveitOrig = _level0.a.giveit;
	_level0.a.giveit = giveit;
	
	_level0.a.firr = firr; // No need for the original here as it's a full override
}

function setupCustomDescriptions() { // Setup our custom descriptions to override the vanilla ones (or missing ones)
	customDescriptions[5] = "Reflective Tears"; // My Reflection
	customDescriptions[8] = "Shooting Familiar"; // Brother Bobby
	customDescriptions[10] = "They're all over me!"; // Halo of Flies
	customDescriptions[17] = "Master Key"; // Skeleton Key
	customDescriptions[19] = "Bombs for days"; // Boom!
	customDescriptions[20] = "I believe I can fly"; // Transcendance
	customDescriptions[21] = "ESP"; // The Compass
	customDescriptions[46] = "You feel lucky"; // Luck Foot
	customDescriptions[54] = "? marks the spot"; // Treasure Map
	customDescriptions[66] = "Space to use"; // The Hourglass
	customDescriptions[67] = "Gives Hearts"; // Sister Maggy
	customDescriptions[73] = "Meaty!"; // Cube of Meat
	customDescriptions[88] = "He'll eat you up"; // Lil Chubby
	customDescriptions[95] = "Bzzt"; // Robo-Baby
	customDescriptions[98] = "You feel blessed"; // The Relic
	customDescriptions[99] = "Slows enemies"; // Little Gish
	customDescriptions[100] = "He lives"; // Little Steve
	customDescriptions[103] = "Evil"; // Demon Baby
	customDescriptions[117] = "Revenger Pecker"; // Dead Bird
	customDescriptions[118] = "We didn't take it in the last 69 runs!"; // Brimstone
	customDescriptions[141] = "Now dance"; // Pageant Boy
	customDescriptions[163] = "Casper?"; // Ghost Baby
	customDescriptions[165] = "At least it's out of the pool"; // Cat-O-Nine-Tails
	customDescriptions[167] = "Strabic Friend"; // Harlequein Baby
	customDescriptions[168] = "It's a won run"; // Epic Fetus
	customDescriptions[169] = "Big ass eye"; // Polyphemus
	customDescriptions[172] = "Just a prick..."; // Sacrificial Dagger
	customDescriptions[174] = "All the way"; // Rainbow Baby
	customDescriptions[179] = "Do you believe?"; // Fate
	customDescriptions[183] = "Tears + Tear Speed"; // Tooth Picks
	customDescriptions[188] = "On the other side"; // Abel
	customDescriptions[190] = "Burn baby burn"; // Pyro
	customDescriptions[194] = "Shot Speed + Tarrot Card"; // Mom's Coin Purs
	customDescriptions[195] = "Medic!!"; // Mom's Coin Purse
	customDescriptions[198] = "It's a box!"; // Box
}