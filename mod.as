// ORIGINAL FUNCTIONS ================================================================================
var powerlevelOrig = undefined;
var displayCornerMessageOrig = undefined;

// VARIABLES =========================================================================================
var customDescriptions = Array(); // An array of all our custom item descriptions
var pickedUpID = -1; // The ID of the last item picked up

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
	
	if (_level0.a.skiner == 6) {
	  v3 -= 0.25;
	}
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
	
	_level0.a.firr = firr;
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
	customDescriptions[195] = "Medic!!"; // Mom's Coin Purse
	customDescriptions[198] = "It's a box!"; // Box
}