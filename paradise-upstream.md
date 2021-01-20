# paradise-upstream.md
Changelog for changes we incorporate from upstream (Paradise Station).

## 2020-06-25
* Paradise #[13651](https://github.com/ParadiseSS13/Paradise/pull/13651): Bumps to DreamChecker 1.4
    * Removes some redundant unreachable code

* Paradise #[13646](https://github.com/ParadiseSS13/Paradise/pull/13654): Removes Set Background
    * Removes antiquated code that was hypothetically slowing the game down
    * Eliminates `BACKGROUND_ENABLED`

* Paradise #[13654](https://github.com/ParadiseSS13/Paradise/pull/13654): Check antagonists panel fix for wizard apprentices
    * Makes wizard apprentices show up in the check antagonists panel again

* Paradise #[13593](https://github.com/ParadiseSS13/Paradise/pull/13593): Lighting Optimizations
    * Ported some improvements to the overall lighting system
        * Ports tgstation #43816
        * Ports tgstation #45491
        * Ports tgstation #51546

* Paradise #[13644](https://github.com/ParadiseSS13/Paradise/pull/13644): Master Controller Fixes
    * Fixes some potential issues with the Master Controller
        * Ports tgstation #37126
        * Ports tgstation #49848
        * Ports tgstation #49893

* Paradise #[13641](https://github.com/ParadiseSS13/Paradise/pull/13641): Purges a Bunch of In World Calls
    * Performance refactoring; checks against absolutely everything in the world happen less often

* Paradise #[13666](https://github.com/ParadiseSS13/Paradise/pull/13666): Fix sake makiroll recipe, "makiroll" -> "maki roll"
    * Fix "sake maki roll" recipe requiring the wrong ingredients
    * Fix recipe for "tobiko and egg maki" roll using the wrong name ("tobiko maki roll")
    * Rename "makiroll" to "maki roll"

* Paradise #[13664](https://github.com/ParadiseSS13/Paradise/pull/13664): Adds missed fingerprints logging to papers and adds normal logging
    * Adding a paper to an airlock is now logged under misc
    * Removing a paper from an airlock is now logged under misc.
    * Removing a paper from a paperbin will generate a fingerprint on the paper
    * Removing a pinned paper from an airlock will generate a fingerprint on the paper
    * Adding a paper to an airlock will generate a fingerprint on the paper

* Paradise #[13662](https://github.com/ParadiseSS13/Paradise/pull/13662): Removes some old and broken features
    * Fixes a few problems the langserver complained at
    * Removed Atmospheric Automations Console
    * Removed logic gates
    * Removed Trams (Yes, trams. We had those)

* Paradise #[13669](https://github.com/ParadiseSS13/Paradise/pull/13669): Kills off (hopefully) the last hardcoded zlevel ID
    * Blackbox now looks for which ZLevel is the admin ZLevel instead of just assuming Z2

* Paradise #[13545](https://github.com/ParadiseSS13/Paradise/pull/13545): Nerfs Trashbags
    * Trashbags no longer fit on belts
    * Trashbags are always bulky, even when empty
    * Fixes regular trashbags only being able to hold 14 items

* Paradise #[13542](https://github.com/ParadiseSS13/Paradise/pull/13542): Hierophant Buff--Staff Nerf
    * Hierophant has been made considerably strong when fighting it in melee range
    * Hierophant staff damage and range values can't go negative, making them insanely strong

* Paradise #[13583](https://github.com/ParadiseSS13/Paradise/pull/13583): Adds Swarming Component
    * Bees, legions, and viscerators can now all swarm, making them significantly more difficult to fight
    * Spiderlings can swarm, though this is mostly aesthetic

* Paradise #[13672](https://github.com/ParadiseSS13/Paradise/pull/13672): Fix carbon hitby proc not returning parent result
    * Fix thrown bolas (and other items) ignoring being blocked by a weapons and shields

* Paradise #[13557](https://github.com/ParadiseSS13/Paradise/pull/13557): Re-adds NTTC filtering
    * Re-added NTTC filtering

* Paradise #[13515](https://github.com/ParadiseSS13/Paradise/pull/13515): Fixes the Changeling tentacle grab logging
    * Fixes the logging for using the changeling tentacle on grab intent

* Paradise #[13509](https://github.com/ParadiseSS13/Paradise/pull/13509): Ghosts can now hear guardian communication again
    * Ghosts can now hear guardian communication again

* Paradise #[13677](https://github.com/ParadiseSS13/Paradise/pull/13677): Allows SSinput to recover after an MC crash
    * Adds `/datum/controller/subsystem/input/Recover`

* Paradise #[13676](https://github.com/ParadiseSS13/Paradise/pull/13676): Makes the assembly cooldown happen before it triggers. Stopping an infinite loop
    * Fixes a potential infinite loop in assembly grenades

* Paradise #[13679](https://github.com/ParadiseSS13/Paradise/pull/13679): Removes an unused proc
    * Removes `/obj/item/reagent_containers/food/snacks/grown/Crossed`
    * Removes `/obj/item/grown/Crossed`
    * Removes `/datum/plant_gene/trait/proc/on_cross`

* Paradise #[13678](https://github.com/ParadiseSS13/Paradise/pull/13678): Adds whispering to the whisper verb
    * Whispers are now logged in `SAY_LOG`

* Paradise #[13683](https://github.com/ParadiseSS13/Paradise/pull/13683): Adds Global Carbon and Human Lists
    * Creates `GLOB.carbon_list` and `GLOB.human_list` that track carbons and humans respectively

* Paradise #[13682](https://github.com/ParadiseSS13/Paradise/pull/13682): Slightly improves the speed at which the crew monitor gets its data
    * Reworks the way crew member health data is processed

* Paradise #[13602](https://github.com/ParadiseSS13/Paradise/pull/13602): Gas Mixture Refactor
    * NOTE: This changeset was quite extensive and was not fully reviewed when merged to Scorpio Station
    * Replaces the trace gasses list with specific managed gas variables

* Paradise #[13663](https://github.com/ParadiseSS13/Paradise/pull/13663): Optimize memory usage by eliminating/changing some lists
    * NOTE: This changeset was quite extensive and was not fully reviewed when merged to Scorpio Station
    * Ported from TG: Object armors are no longer defined in (unique) lists but rather datums that can be cached depending on their armor values.
    * Adds LAZYSET define to lazily initialize a list then assigning a key to a value
    * Adds alldirs2 global which is the same as alldirs except diagonals go first
    * Optimizes atom memory by not creating hud_list list for all atoms
    * Optimizes turf memory by not creating footstep_sounds list for all turfs
    * Optimizes mob memory by making alerts list lazy
    * Optimizes obj/machinery memory by making use_log and settagwhitelist lists lazy
    * Cleans up code where possible

* Paradise #[13689](https://github.com/ParadiseSS13/Paradise/pull/13689): Structures Armor Fix
    * Moves armor initialization from `New` to `Initialize` for `/obj/structure`

## 2020-06-18
* Paradise #[12891](https://github.com/ParadiseSS13/Paradise/pull/12891): Adds IPC plushie and toast, toast is made via IPC plushie
    * IPC plushie and toast

* Paradise #[13622](https://github.com/ParadiseSS13/Paradise/pull/13622): Fixes shuttle exploit
    * Fixed an exploit with shuttle code

* Paradise #[13624](https://github.com/ParadiseSS13/Paradise/pull/13624): minor fix
    * minor formatting fix in toy foamblade

* Paradise #[13608](https://github.com/ParadiseSS13/Paradise/pull/13608): Removes references to console screens and removes an unnecessary var from circuitboards
    * Examine text for circuit boards that require more than 1 of a part will now have an "s" on the end of the name of that part
        * For example "2 capacitor" becomes "2 capacitors"

* Paradise #[13611](https://github.com/ParadiseSS13/Paradise/pull/13611): Removes Non-existent docking port from Delta
    * ScorpioStation kept this when de-conflicting the merge; shrug

* Paradise #[13605](https://github.com/ParadiseSS13/Paradise/pull/13605): Correcting Welder Messages on the Field Generator
    * Replicates ScorpioStation #[47](https://github.com/ScorpioStation/ScorpioStation/pull/47) without the grammar fix

* Paradise #[13594](https://github.com/ParadiseSS13/Paradise/pull/13594): Updates Components
    * Modifies the way some things are handled internally to a Component style

* Paradise #[13384](https://github.com/ParadiseSS13/Paradise/pull/13384): Explorer Transfers
    * 'Explorer' is now a job transfer option in the ID computer

* Paradise #[13629](https://github.com/ParadiseSS13/Paradise/pull/13629): Fixes a Couple of Components Things
    * Fixes incorrect file path for the components readme/documentation
    * Also fixes a spelling issue with grumpy fox plushie

* Paradise #[13616](https://github.com/ParadiseSS13/Paradise/pull/13616): Fix HUDs taking parent atom's color
    * Fix HUDs being rendered with colour of the object they belong to

* Paradise #[13618](https://github.com/ParadiseSS13/Paradise/pull/13618): Ports TGs way of handling bullet_act on shooting targets
    * Should fix the armory crash

* Paradise #[13630](https://github.com/ParadiseSS13/Paradise/pull/13630): Minor refactor to wireless eguns
    * Optimised the code of wireless eguns

* Paradise #[13623](https://github.com/ParadiseSS13/Paradise/pull/13623): Fixes Shadowling darksight not giving night vision when toggled
    * Fixed the shadowling darksight not toggling night vision without something else updating your vision

* Paradise #[13627](https://github.com/ParadiseSS13/Paradise/pull/13627): Fixes No Slip Shoes
    * Fixes no slips not working

* Paradise #[13620](https://github.com/ParadiseSS13/Paradise/pull/13620): Fixes Unhackable Smartfridges
    * Fixes being unable to disable ID scan on a smartfridge
    * Smartfridges now check to see if they are verifying IDs before denying access due to ID

* Paradise #[13591](https://github.com/ParadiseSS13/Paradise/pull/13591): Resolves some Reagent Runtimes
    * Slight change to messages when using ethanol on paper and books
    * Modifies the way mob life processes synthanol

## 2020-06-11
* Paradise #[13535](https://github.com/ParadiseSS13/Paradise/pull/13535): Patches a hole
    * Mentors can no longer invoke player panel via F7

* Paradise #[13536](https://github.com/ParadiseSS13/Paradise/pull/13536): Various Life Refactor Fixes
    * Fixes guardians view being locked to the player
    * Fixes SSD players being woken up and not going back to sleep
    * Maybe fixes mobs ending up in null location unassigned to any z-level by going in disposals?

* Paradise #[13539](https://github.com/ParadiseSS13/Paradise/pull/13539): Fix AI say logging and cult logging
    * Cult commune is logged in the say log as well now
    * AIs saying stuff on channels is logged again
    * AIs saying stuff on channels is logged again

* Paradise #[13543](https://github.com/ParadiseSS13/Paradise/pull/13543): Terror queens that evolve from princesses will now be able to see their medhud properly
    * Terror queens that evolve from princesses will now be able to see their medhud properly

* Paradise #[13519](https://github.com/ParadiseSS13/Paradise/pull/13519): Make light_constructs use X_acts. Fixes a runtime
    * Using a wrench on a light construct now won't hit it when you're trying to deconstruct it

* Paradise #[13528](https://github.com/ParadiseSS13/Paradise/pull/13528): Renames the old station Delta wing to Theta
    * The oldstation Delta wing has been renamed to Theta.

* Paradise #[13504](https://github.com/ParadiseSS13/Paradise/pull/13504): Fixes the cloning pod turning invisible when you use a screwdriver on it
    * Fixes the cloning pod turning invisible when you use a screwdriver on it

* Paradise #[13507](https://github.com/ParadiseSS13/Paradise/pull/13507): Cyborgs can't look inside storage containers with alt-click anymore
    * Cyborgs can't look inside storage containers with alt-click anymore
    * Alt-clicking on a storage container while it's on the floor will bring up the examine tab which lists a turf's contents

* Paradise #[13469](https://github.com/ParadiseSS13/Paradise/pull/13469): Karma menu update
    * Fixes Karma menu not showing current karma
    * Fixes Karma menu not showing unlocked jobs/species

* Paradise #[13490](https://github.com/ParadiseSS13/Paradise/pull/13490): Gives flashes and cameras a light flash
    * Gives a flasher (portable and brig flashers) a light flash after it is used
    * Gives a flash a light flash after it is used
    * Gives a camera a light flash after it is used

* Paradise #[13514](https://github.com/ParadiseSS13/Paradise/pull/13514): Changes the changelings absorb objective description to be more clear
    * Tweak changelings absorb objective description is made more descriptive
    * Tweak changelings spread infestation power description is made more clear

* Paradise #[13117](https://github.com/ParadiseSS13/Paradise/pull/13117): Rework power outage event
    * Removes moderate event Grid Check
    * Adds moderate event APC Short
    * Adds major event APC Overload

* Paradise #[13332](https://github.com/ParadiseSS13/Paradise/pull/13332): Improves / Reworks Dark Gygax for Nuke Ops
    * Improves Dark Gygax stats and equipment

* Paradise #[13524](https://github.com/ParadiseSS13/Paradise/pull/13524): Programmatic Profiler Access
    * The ingame profiler is now granted to people with R_DEBUG and R_VIEWRUNTIMES

* Paradise #[12842](https://github.com/ParadiseSS13/Paradise/pull/12842): AFK subsystem now also despawns certain antags
    * The autocryoing preference now also works for certain antags.
        * Others like shadowlings won't get cryod but instead will send a message to admins that they are AFK.
    * The autocryoing preference now will give feedback in the chat informing the player about the option when used.
    * SSAfk subsystem now sends less messages to admins. Only when it cannot make a decision itself.

* Paradise #[13555](https://github.com/ParadiseSS13/Paradise/pull/13555): Fixes karma shop
    * Karma shop actually registers if you have brig phys unlocked

* Paradise #[13556](https://github.com/ParadiseSS13/Paradise/pull/13556): Personal closet fix, makes it respect nodrop
    * Clicking open personal closets with nodrop items will no longer place that item into the locker

* Paradise #[13534](https://github.com/ParadiseSS13/Paradise/pull/13534): Organ processing performance
    * Massive doses of spaceacillin no longer prevents organ necrosis from ever happening
    * Buffs spaceacillin just a hair by making it kill a couple more germs per cycle
    * Improves processing of organs so it improves game performance

* Paradise #[13564](https://github.com/ParadiseSS13/Paradise/pull/13564): Dramatically Cuts Object Processing Down
    * Dramatically improves object processing performance

* Paradise #[13561](https://github.com/ParadiseSS13/Paradise/pull/13561): Fixes Excessive PDA Creation
    * Fixes thousands of PDA's being created in a round, decreasing game performance

* Paradise #[13563](https://github.com/ParadiseSS13/Paradise/pull/13563): Fixes Epilepsy Having Epilepsy
    * Fixes message for epilepsy

* Paradise #[13562](https://github.com/ParadiseSS13/Paradise/pull/13562): Fixes Vampire Vision
    * Fixes vampire vision not updating when you get the proper blood level

* Paradise #[13487](https://github.com/ParadiseSS13/Paradise/pull/13487): NanoUI Brig Timers
    * Converts brig timers to NanoUI

* Paradise #[13568](https://github.com/ParadiseSS13/Paradise/pull/13568): Fixes Shoe Shackle Handcuff Upgrading
    * Fixes being able to upgrade cablecuffs to regular cuffs with shackled shoes

* Paradise #[13572](https://github.com/ParadiseSS13/Paradise/pull/13572): Gamebreaking bug fix immediately
    * Renames default subsystem from `fire coderbus` to `fire codertrain`

* Paradise #[13580](https://github.com/ParadiseSS13/Paradise/pull/13580): Fixes Ghost Exploit
    * Patches a ghost exploit

* Paradise #[13586](https://github.com/ParadiseSS13/Paradise/pull/13586): Fixes an issue with personal closets
    * Fixes an issue with personal lockers

* Paradise #[13582](https://github.com/ParadiseSS13/Paradise/pull/13582): Cuts down on Pointless Status Effect Processing
    * Cuts down on processing time of lavaland mobs

* Paradise #[13571](https://github.com/ParadiseSS13/Paradise/pull/13571): Fixes the mech repair droid being undetachable from mechs
    * Fixes the mech repair droid being undetachable from mechs

* Paradise #[13589](https://github.com/ParadiseSS13/Paradise/pull/13589): Brigtimer runtime fix
    * Brig timer runtime fix

* Paradise #[12853](https://github.com/ParadiseSS13/Paradise/pull/12853): Makes tanks dispensed from tank storage units get placed into your hands
    * Tanks dispensed from tank storage units now get placed into your hands, if your hands are not full

* Paradise #[13552](https://github.com/ParadiseSS13/Paradise/pull/13552): Fixes the steal objective from runtiming
    * Fixes a runtime where a cryod antag breaks the steal objective. Thus not showing the objective at the end and causing tons of runtimes

* Paradise #[13558](https://github.com/ParadiseSS13/Paradise/pull/13558): Adds the slippery component
    * Modifies the way slippery atoms are handled; modified component import from TG

* Paradise #[13595](https://github.com/ParadiseSS13/Paradise/pull/13595): Updates nano dependencies
    * Update for dependencies for NanoUI; no game effect

### Modified
* Paradise #[13532](https://github.com/ParadiseSS13/Paradise/pull/13504): Removes something which shouldnt really exist here
    * Scorpio Station kept the human-snake body modification monster thingy
    * Code to sanitize an unknown body_accessory in `/datum/preferences/proc/load_character` was not reverted

## 2020-06-03
* Paradise #[13511](https://github.com/ParadiseSS13/Paradise/pull/13511): Fixes whiteship spawning above station
    * The white ship no longer spawns above the station

* Paradise #[13506](https://github.com/ParadiseSS13/Paradise/pull/13506): Helps Organs GC Better
    * Adds `/obj/item/organ/internal/brain/Destroy()` to clean up after brains
    * Converts many `spawn` instances to `addtimer` callbacks

* Paradise #[13526](https://github.com/ParadiseSS13/Paradise/pull/13516): You won't hit an airlock now when using a wirecutter on it while the panel is open
    * You won't hit an airlock now when using a wirecutter on it while the panel is open

* Paradise #[13516](https://github.com/ParadiseSS13/Paradise/pull/13516): Cleans up some awful code from the ticker
    * Optimised part of the Ticker Subsystem code
    * Modifies the subsystems related to statistics; admin and player population
    * Modifies the subsystems related to vote timing; crew transfer shuttle

* Paradise #[13513](https://github.com/ParadiseSS13/Paradise/pull/13513): Fixes the virus outbreak event, including naming
    * Random normal viruses from the virus outbreak event now actually spawn instead of runtime and make everybody sad
    * Random advanced viruses from the virus outbreak event now have proper working names

* Paradise #[13471](https://github.com/ParadiseSS13/Paradise/pull/13471): Life refactor
    * Note: This is a very large changeset (183 files); it was not fully reviewed for Scorpio
    * All mobs, including simple mobs, have a health icon now
    * Health and health doll should update more responsively
    * Buffs remote view a bit; lowers the cooldown and makes it able to be cancelled; you no longer appear in the list of remote viewable mobs
    * All mobs will now float up and down if they are flying
    * Robots that lose an equipment slot to damage now play an audible sound
    * Robots who lose control of one of their equipment slots can't re-equip an item and utilize it for the next two seconds before it unequips again
    * Fixes being dead preventing you from being impacted by weather
    * Fixes nearsighted glasses not rendering in player preview
    * Fixes not getting prescription glasses if you're nearsighted

## 2020-05-28
* Paradise #[13403](https://github.com/ParadiseSS13/Paradise/pull/13403): Cyborg Hypospray QOL tweak
    * Cyborg's hypospay now replenishes reagents in inactive modes once the active mode is full
* Paradise #[13375](https://github.com/ParadiseSS13/Paradise/pull/13375): The logviewer will now work if you have invalid mobs in your selection
    * Remove deleted mobs from the list to allow the logview to open
* Paradise #[12652](https://github.com/ParadiseSS13/Paradise/pull/12652): Fix paperwork acquiring extra line breaks when you change register
    * Pencode and Markdown living together, mass hysteria
* Paradise #[12423](https://github.com/ParadiseSS13/Paradise/pull/12423): Diona nymphs can eat veggies
    * Diona nymphs can eat food and weeds now
* Paradise #[12660](https://github.com/ParadiseSS13/Paradise/pull/12660): Game panel improvements
    * Makes the game panel behave a little more intuitively
* Paradise #[12827](https://github.com/ParadiseSS13/Paradise/pull/12827): Removes the Freeze Mech verb, and bundles its functionality into the Freeze verb
    * Adds a nice message for those attempting to enter an admin-frozen mech
* Paradise #[12820](https://github.com/ParadiseSS13/Paradise/pull/12820): Gives sleepers and cryotubes the ability to auto-eject dead people
    * Modifies the cryotubes and sleepers to allow new auto-eject settings
* Paradise #[13374](https://github.com/ParadiseSS13/Paradise/pull/13374): Newcrit Death Threshold Tweaks
    * Modifies the formula for the death threshold
* Paradise #[13478](https://github.com/ParadiseSS13/Paradise/pull/13478): Fixes a filesystem viewing exploit
    * Fixes security hole whereby arbitrary server files could be read
* Paradise #[13479](https://github.com/ParadiseSS13/Paradise/pull/13479): Fix spelling of Disintegrate
    * Fixes up two spelling errors
* Paradise #[13476](https://github.com/ParadiseSS13/Paradise/pull/13476): This time I dont break logs
    * The MC restarting no longer re-enables OOC
* Paradise #[13468](https://github.com/ParadiseSS13/Paradise/pull/13468): Allows the IPC players to select the bald IPC monitor using the "Change Monitor" button
    * Added the "bald" IPC name and icon_state (Obsoleted by #13483)
* Paradise #[13457](https://github.com/ParadiseSS13/Paradise/pull/13457): Updates the contribution info. Multiplications are not faster than divisions
    * Modifies the code contribution guide on GitHub
* Paradise #[12907](https://github.com/ParadiseSS13/Paradise/pull/12907): Fixes some armour value oversights
    * Adjust the armor values on a handful of security items to make them more consistent
* Paradise #[13443](https://github.com/ParadiseSS13/Paradise/pull/13443): Fire Cult sprite overhaul
    * Incredible new graphics and thematic mob names for fire cult; no gameplay changes
* Paradise #[13462](https://github.com/ParadiseSS13/Paradise/pull/13462): Replaces the bloodcrawl variable with a trait
    * Refactors variable `bloodcrawl` into two new traits `TRAIT_BLOODCRAWL` and `TRAIT_BLOODCRAWL_EAT`
    * `TRAIT_WATERBREATH` was also added, because hey, why not
* Paradise #[13430](https://github.com/ParadiseSS13/Paradise/pull/13430): Removes Fat Sprites
    * Fat condition remains, but the sprites to show it are removed
* Paradise #[12666](https://github.com/ParadiseSS13/Paradise/pull/12666): Adds new SecHUD designations and tweaks secHUD on examining
    * Nice enhancements to the Security HUD
* Paradise #[13483](https://github.com/ParadiseSS13/Paradise/pull/13483): Fixes Having a Frigging Monitor Glued to Your Face
    * Fixes the name and icon_state of "bald" IPCs
* Paradise #[13481](https://github.com/ParadiseSS13/Paradise/pull/13481): Makes explicit paths in the code/datums/periodic_news.dm file
    * No gameplay change; improves code-quality
* Paradise #[13453](https://github.com/ParadiseSS13/Paradise/pull/13453): Removes Unused Factions
    * Removes Syndicate factions from the game; they weren't used
* Paradise #[13438](https://github.com/ParadiseSS13/Paradise/pull/13438): Ports Cybernetic Ears
    * Adds cybernetic ears
    * Fixes bug with cybernetic eye appearance
* Paradise #[13449](https://github.com/ParadiseSS13/Paradise/pull/13449): TG Label Component Port
    * Refactors the labeler to add a label component to an atom
* Paradise #[13482](https://github.com/ParadiseSS13/Paradise/pull/13482): IPCs can now change their monitors while laying down
    * Modifies the `incapacitated` check to allow IPCs to do this
* Paradise #[13488](https://github.com/ParadiseSS13/Paradise/pull/13488): Makes airlocks destroyable again using weapons when the panel is open
    * Changes a small bit of logic in `code/game/machinery/doors/airlock.dm`
* Paradise #[13446](https://github.com/ParadiseSS13/Paradise/pull/13446): Telecommunications Overhaul
    * Reworks Telecomms into two machines: Core and Relays
    * Dramatically improves server side performance
* Paradise #[13497](https://github.com/ParadiseSS13/Paradise/pull/13497): Fixes Intercomms and Station Bounce Radios
    * Changes when broadcast messages are deleted so that intercoms and radios still work
* Paradise #[13495](https://github.com/ParadiseSS13/Paradise/pull/13495): Library computer fix
    * Fixes message monitor key not working (Obsoleted by #13498)
* Paradise #[13486](https://github.com/ParadiseSS13/Paradise/pull/13486): Library computer fix
    * Makes the library computer print the correct manuals.
* Paradise #[13498](https://github.com/ParadiseSS13/Paradise/pull/13498): Minor tcomms fixes
    * Adjusts message in `/obj/item/paper/tcommskey/LateInitialize`
* Paradise #[13505](https://github.com/ParadiseSS13/Paradise/pull/13505): Annihilates the global iterator
    * An ancient and vestigial mode of processing is removed from the codebase

### Modified
* Paradise #[13477](https://github.com/ParadiseSS13/Paradise/pull/13477): Lizard skin handbag
    * Adds `lizard skin handbag`, a satchel made of Unathi skins
    * Scorpio Station removed the crafting recipe for the bag:
        * Admins can spawn the bag for a Hannibal Lecter style villain if they want
        * Players cannot craft the bag themselves

## 2020-05-21
* Paradise #[13442](https://github.com/ParadiseSS13/Paradise/pull/13411): Subsystems now state implications if offlined
    * Adds `offline_implications` text to subsystems so admins can be aware of their purpose/effect
* Paradise #[13442](https://github.com/ParadiseSS13/Paradise/pull/13442): Your ears feel great
    * Tweaks the messaging on the sensory restoration virus
* Paradise #[13143](https://github.com/ParadiseSS13/Paradise/pull/13143): Makes classic secHUD available to Magistrate
    * Adds `Magistrate` to the `allowed_roles` of `/datum/gear/sechud`
* Paradise #[13448](https://github.com/ParadiseSS13/Paradise/pull/13448): Fixes Admin Logs
    * Moves some log initialization code to the top of `/datum/controller/master/New()`
* Paradise #[13334](https://github.com/ParadiseSS13/Paradise/pull/13334): Direction Locking Help Text
    * Adds a helpful message when you direction-lock your character
* Paradise #[13445](https://github.com/ParadiseSS13/Paradise/pull/13445): Makes round end more obvious in game logs
    * Uses multiple log messages to create a banner effect making it easier to see exactly when a round ended
* Paradise #[13282](https://github.com/ParadiseSS13/Paradise/pull/13282): Remove crowbarring sound on blast doors and update the proc
    * Turns down the tool volume on crowbarring a door
* Paradise #[12647](https://github.com/ParadiseSS13/Paradise/pull/12647): Makes some space ruins easier to find
    * Adds `/obj/item/gps/ruin` to space ruins to help make them easier to find
* Paradise #[12795](https://github.com/ParadiseSS13/Paradise/pull/12795): Emagproofs CC, adds admin warning if ert shuttle is moved by non-ert
    * Adds an admin message is the shuttle is moved by unauthorized folks
* Paradise #[13450](https://github.com/ParadiseSS13/Paradise/pull/13450): Fixes missing Syndicate Spacesuit sprite
    * Adds missing suit icons to `icons/mob/species/tajaran/suit.dmi`
* Paradise #[13051](https://github.com/ParadiseSS13/Paradise/pull/13051): Changelog Overhaul
    * Adds a database based changelog system
* Paradise #[13395](https://github.com/ParadiseSS13/Paradise/pull/13395): Shock Proof Heart
    * Adds a check for `emp_proof` to `/obj/item/organ/internal/heart/cybernetic/upgraded/shock_organ`
* Paradise #[13157](https://github.com/ParadiseSS13/Paradise/pull/13157): Lighter refactor + Reduces zippo lighter and gavel text and sound spam
    * Adds a 5 second cooldown to gavel and zippo lighter to reduce spam
    * Refactors zippo lighter use to `turn_on_lighter` and `turn_off_lighter` procs
* Paradise #[13426](https://github.com/ParadiseSS13/Paradise/pull/13426): Removes gottagofast_meth
    * Eliminates speed stacking meth with other speedups
    * Removes define flag `GOTTAGOFAST_METH`
    * Refactors code to use `GOTTAGOFAST` in place of `GOTTAGOFAST_METH`
* Paradise #[13452](https://github.com/ParadiseSS13/Paradise/pull/13452): CL Fixes Round 1
    * Fixes runtime with changelog system
    * Makes changelog entries open in external browser
* Paradise #[13432](https://github.com/ParadiseSS13/Paradise/pull/13432): Unscrewing Lava
    * Adds no-op `/turf/open/floor/plating/lava/screwdriver_act()` to prevent unscrewing lava
* Paradise #[13205](https://github.com/ParadiseSS13/Paradise/pull/13205): Add wizard loadouts, misc wiz features/fixes
    * Extensive changes to the wizard loadout system, including new sprites
* Paradise #[13454](https://github.com/ParadiseSS13/Paradise/pull/13454): Fixes Meatball in-hand icons
    * Modifies `icons/mob/inhands/items_lefthand.dmi`
    * Modifies `icons/mob/inhands/items_righthand.dmi`
* Paradise #[13455](https://github.com/ParadiseSS13/Paradise/pull/13455): Removes a bunch of unused vars
    * Removes many unused variables across 4 source files
* Paradise #[13460](https://github.com/ParadiseSS13/Paradise/pull/13460): BSA strikes are now logged to disk
    * Adds a log message for BSA usage
* Paradise #[13436](https://github.com/ParadiseSS13/Paradise/pull/13436): Lighting Performance Improvement
    * Changes some lighting related procs to macros to improve performance
* Paradise #[13473](https://github.com/ParadiseSS13/Paradise/pull/13473): Fixed db version in dbconfig example file
    * Bump from schema v11 to schema v12

## 2020-05-14
* Paradise #[13360](https://github.com/ParadiseSS13/Paradise/pull/13360): Fixes the missionary staff being unable to charge properly
    * Adds `get_dist` check to make missionary staff charge properly
* Paradise #[13380](https://github.com/ParadiseSS13/Paradise/pull/13380): Adds MC VIEWING to the VIEWRUNTIMES permission
    * Adds check for `VIEWRUNTIMES` permission to see Master Controller tab
* Paradise #[13406](https://github.com/ParadiseSS13/Paradise/pull/13406): Fixes MC perms spam
    * Adds `FALSE` to prevent MC permissions checks from being logged
* Paradise #[13415](https://github.com/ParadiseSS13/Paradise/pull/13415): Reduces automender attack log spam
    * Adds a check for `emagged` to reduce log spam
* Paradise #[13419](https://github.com/ParadiseSS13/Paradise/pull/13419): Medicines now properly sate addiction when smoked.
    * Adds a call to `sate_addiction` in `/datum/reagent/medicine/on_mob_life`
* Paradise #[13421](https://github.com/ParadiseSS13/Paradise/pull/13421): Fixes and pressing issue in a certain system
    * Added check to prevent ghosts from getting shocked
    * Obsoleted by Paradise #[13422](https://github.com/ParadiseSS13/Paradise/pull/13422)
* Paradise #[13422](https://github.com/ParadiseSS13/Paradise/pull/13422): Prevents Shocking non-living Mobs
    * Changes `/obj/machinery/proc/shock` to accept `mob/living` instead of `mob`
* Paradise #[13427](https://github.com/ParadiseSS13/Paradise/pull/13427): Fixed description for corporate cap
    * Fixes item `desc` for `/obj/item/clothing/head/soft/sec` and `/obj/item/clothing/head/soft/sec/corp`
* Paradise #[13401](https://github.com/ParadiseSS13/Paradise/pull/13401): Borgs can no longer access mounted defibs
    * Adds a NO-OP `/obj/machinery/defibrillator_mount/attack_ai` to prevent borgs from using the wall defibs
* Paradise #[13414](https://github.com/ParadiseSS13/Paradise/pull/13414): Fixes some runtimes
    * Adds some checks to avoid runtimes
    * Moves a call to super in `/obj/structure/lattice/catwalk/swarmer_act`
* Paradise #[13408](https://github.com/ParadiseSS13/Paradise/pull/13408): Moves config loading to world/New not Master/New
    * Moves `load_configuration()` from `/datum/controller/master/New` to `/world/New`
* Paradise #[13394](https://github.com/ParadiseSS13/Paradise/pull/13394): Fixes the sensory restoration symptom message
    * Fixes typo from `healing` to `hearing`
* Paradise #[13396](https://github.com/ParadiseSS13/Paradise/pull/13396): Makes trail_holders (blood trails) invisible upon examine.
    * Explicitly sets `/obj/effect/decal/cleanable/trail_holder` to have no icon to prevent client crashes/lag
* Paradise #[13399](https://github.com/ParadiseSS13/Paradise/pull/13399): Grammar and typo fixes
    * Fixed grammar in flash message in `code/game/objects/items/devices/flash.dm`
    * Fixed variable name typo in `code/modules/reagents/chemistry/holder.dm`
* Paradise #[13431](https://github.com/ParadiseSS13/Paradise/pull/13431): Headcrab death check
    * Dead Headcrabs no longer try to zombify dead humans or eat dead animals
    * Calls super to check for life before processing Life in `/mob/living/simple_animal/hostile/headcrab/Life`
* Paradise #[13400](https://github.com/ParadiseSS13/Paradise/pull/13400): Makes it so you can't repair wooden barricades with a welder
    * Adds a check to `/obj/structure/barricade/welder_act` to ensure the barricade is made out of `METAL` before allowing repair
* Paradise #[12899](https://github.com/ParadiseSS13/Paradise/pull/12899): Gas Mix Mistake Fix
    * Fixes a comparison to the oxygen level when mixing carbon dioxide
* Paradise #[13437](https://github.com/ParadiseSS13/Paradise/pull/13437): fixed apples not distilling in fermenting barrels
    * Fixed the name of `distill_reagent` in `code/modules/hydroponics/grown/apple.dm`
* Paradise #[13387](https://github.com/ParadiseSS13/Paradise/pull/13387): GC Fixes
    * Fixes some circular references to allow better GC
    * Fixed check for `user.incapacitated()` in `/obj/item/enginepicker/attack_self`
    * Fixes references to globals without `GLOB` in `TESTING` defined code
* Paradise #[13397](https://github.com/ParadiseSS13/Paradise/pull/13397): Fixes Chainsaw hitsound
    * Adds null `hitsound` field to `/obj/item/twohanded/chainsaw` to allow custom sound handling
* Paradise #[13420](https://github.com/ParadiseSS13/Paradise/pull/13420): Refactor and Fixes EMP's
    * Refactors logic in `emp_act` across containers, items, and mobs to prevent duplicate firing

## 2020-05-07
* Paradise #[13250](https://github.com/ParadiseSS13/Paradise/pull/13250): Adds vox bone armor sprites
    * Adds pixels and icon states for bone armor to `icons/mob/species/vox/suit.dmi`
* Paradise #[13111](https://github.com/ParadiseSS13/Paradise/pull/13111): Rewrites confirmation prompt for touching SSD players
    * Modifies the SSD message in `code/modules/client/client procs.dm`
* Paradise #[13356](https://github.com/ParadiseSS13/Paradise/pull/13356): Fixes ticker force-end
    * Allows `force_ending` to change the Ticker state to `GAME_STATE_FINISHED`
    * Example: Malf AI uses Doomsday; now the round will end properly and restart
* Paradise #[13342](https://github.com/ParadiseSS13/Paradise/pull/13342): You can now use movement keys to move out of a cryosleep pod
    * Adds ability to use movement keys to get out of a cryopod
* Paradise #[13343](https://github.com/ParadiseSS13/Paradise/pull/13343): Makes ai_monitored load the cams on LateInitialize
    * Moves some camera initialization code from a `spawn(20)` to the `LateInitalize` hook
* Paradise #[13335](https://github.com/ParadiseSS13/Paradise/pull/13335): Makes 'nodecon' walls on derelict russian station immune to welders
    * Implements `/turf/simulated/wall/mineral/titanium/nodecon/welder_act` as a No-Op
* Paradise #[13313](https://github.com/ParadiseSS13/Paradise/pull/13313): Fixes unexpected gibbing in TS away mission
    * Fixes code that gibs you if bring terror spider eggs back to the main station
        * During `on_life` the check would be triggered by entering a container; it now checks your turf instead
* Paradise #[12950](https://github.com/ParadiseSS13/Paradise/pull/12950): Fixes steal station blueprints objective
    * Steal station blueprints objective now requires either the CE's actual blueprints, or a photograph of them
    * Stops the advanced pinpointer from pointing at slime and cyborg blueprints
    * Changes the theft objective to new type `/obj/item/areaeditor/blueprints/ce`
* Paradise #[13046](https://github.com/ParadiseSS13/Paradise/pull/13046): Fixes cult sacrifice targeting offstation roles
    * Uses `player.mind.offstation_role` to prevent inappropriate sacrifice selection
* Paradise #[12946](https://github.com/ParadiseSS13/Paradise/pull/12946): Fixed a few funtimes and bugs
    * Fixes constructs not being able to teleport using teleport runes.
    * Fixes constructs not being able to be teleported by the Rite of Joined Souls rune.
    * Nuking the station won't cause runtimes anymore. People can now also walk after being nuked and living
* Paradise #[13181](https://github.com/ParadiseSS13/Paradise/pull/13286): fixes smoking and similar incremental dosage systems for addiction
    * Changes the way reagents are processed for addiction
        * Adds `/datum/reagent/proc/sate_addiction` to handle getting a fix for your addiction
* Paradise #[13286](https://github.com/ParadiseSS13/Paradise/pull/13286): Nanopaste resizeing (w_class)
    * Changes Nanopaste to a tiny item, so it fits more appropriately
    * Adds `w_class = WEIGHT_CLASS_TINY` to `/obj/item/stack/nanopaste`
* Paradise #[13308](https://github.com/ParadiseSS13/Paradise/pull/13308): Sprite update to Lumi's vox fluff
    * Sprite change for fluff item
    * Changes `/obj/item/clothing/under/fluff/voxbodysuit` to `/obj/item/clothing/under/fluff/kikeridress`
* Paradise #[13346](https://github.com/ParadiseSS13/Paradise/pull/13346): Removes AI notification on pAI hacking doors
    * The AI no longer receives a notice that a pAI is hacking a door
        * Logic was removed from `code/modules/mob/living/silicon/pai/software_modules.dm`
* Paradise #[13284](https://github.com/ParadiseSS13/Paradise/pull/13284): Deconstructing and mice biting wires is now put in the investigation log
    * Adds investigate logging calls for wire deconstruction
* Paradise #[12674](https://github.com/ParadiseSS13/Paradise/pull/12674): Minor cargo supply crate pathing change
    * Moves the "Hydroponics Watertank Crate" into the "Food and Livestock" section next to the rest of the hydroponics gear
    * Simple re-path from `/datum/supply_packs/misc/hydroponics/hydrotank` to `/datum/supply_packs/organic/hydroponics/hydrotank`
* Paradise #[12726](https://github.com/ParadiseSS13/Paradise/pull/12726): Added CC Stamp to Navy Officer's backpacks
    * Adds a `/obj/item/stamp/centcom` to Navy Officer's backpack on spawn
* Paradise #[13362](https://github.com/ParadiseSS13/Paradise/pull/13362): CI Hotfix
    * Improves code quality in `code/modules/customitems/item_defines.dm`
* Paradise #[13062](https://github.com/ParadiseSS13/Paradise/pull/13062): Patch rework
    * Patches no longer instantly heal, but apply slowly over time.
    * Adds new auto-mender device that can apply medicine to patients in a rapid manner
    * Creates a `safe_chem_applicator_list` to control what can go in a non-emagged applicator
    * Note: This is a large changeset and time constraints prevented a thorough code review
* Paradise #[13368](https://github.com/ParadiseSS13/Paradise/pull/13368): Fixes the crossbow's cell being un-removable with a screwdriver
    * Fixes bug where screwdriver cannot remove cell from crossbow
    * Refactors screwdriver action logic to `/obj/item/gun/throw/crossbow/screwdriver_act`
* Paradise #[13344](https://github.com/ParadiseSS13/Paradise/pull/13344): Makes wand of door creation not work on wizard den
    * Adds `no_den_usage = TRUE` to the wand of door creation to prevent exploits
* Paradise #[12696](https://github.com/ParadiseSS13/Paradise/pull/12696): Makes simple slimes ignore slime people when searching for targets again
    * Slimes don't try to eat slime people any more
    * Adds `inherent_factions` to `code/modules/mob/living/carbon/human/species/_species.dm`
        * Slimes, Diona, and others are given specific factions
* Paradise #[13379](https://github.com/ParadiseSS13/Paradise/pull/13379): Fixes part of Travis I forgot about
    * Improves code quality related to global variables across the codebase
    * Adds checks to Paradise CI infrastructure
* Paradise #[13386](https://github.com/ParadiseSS13/Paradise/pull/13386): Fixes Chem Grenades
    * Fixes a bug that prevented grenades from reacting
* Paradise #[13369](https://github.com/ParadiseSS13/Paradise/pull/13369): Vendor refactor
    * Improves code quality of vending machines; no gameplay change
* Paradise #[13392](https://github.com/ParadiseSS13/Paradise/pull/13392): Removes fires from depot
    * Changes were made to the Syndicate Depot in hopes of curbing Master Controller issues

### Rejected
* Paradise #[13351](https://github.com/ParadiseSS13/Paradise/pull/13351): Adds Linux Support
    * Adds support libraries and some documentation for Linux
    * Scorpio Station obtains these libraries in a different way, so we won't use these
        * `git revert -m 1 502ff13461`
* Paradise #[13357](https://github.com/ParadiseSS13/Paradise/pull/13357): Update mob glide_size prior to movement
    * This code may introduce movement and/or visual bugs
    * This merge is controversial on Paradise
        * https://github.com/ParadiseSS13/Paradise/pull/13364
        * https://github.com/ParadiseSS13/Paradise/pull/13381
    * Scorpio Station will be conservative and reject this merge for now
        * `git revert -m 1 66d56e858e`
* Paradise #[13367](https://github.com/ParadiseSS13/Paradise/pull/13367): Fix up smooth movement issues
    * This code may introduce movement and/or visual bugs
    * This merge is controversial on Paradise
        * https://github.com/ParadiseSS13/Paradise/pull/13364
        * https://github.com/ParadiseSS13/Paradise/pull/13381
    * Scorpio Station will be conservative and reject this merge for now
        * `git revert -m 1 4118b4c8f9`

## 2020-04-23
* Paradise #[13324](https://github.com/ParadiseSS13/Paradise/pull/13324): Makes the water tank backpack nozzle not have antidrop
    * Removes NODROP from the water tank backpack nozzle
* Paradise #[13317](https://github.com/ParadiseSS13/Paradise/pull/13317): Fixes the collar slot accepting everything + 2 other runtimes
    * Fixes being able to put any item on a corgi's collar slot.
    * Fixes a runtime when laptops spawn
    * Fixes a runtime due to some hallucinations calling playsound_local to GLOBAL_PROC instead of the target.
* Paradise #[13306](https://github.com/ParadiseSS13/Paradise/pull/13306): Clamp fix beta
    * Changes clamp to Clamp because clamp is only supported on the beta
* Paradise #[13298](https://github.com/ParadiseSS13/Paradise/pull/13298): Envirosuit spelling corrections, part II
    * Corrects spelling and grammar for descriptive text of plasmaman suits in several files
* Paradise #[13287](https://github.com/ParadiseSS13/Paradise/pull/13287): Travis cleanup
    * Streamline and update Travis CI configuration
        * Refactored some to `tools/travis`
    * Added newline endings to several files
    * Renamed `unicode_9_annotations.js` to reflect proper type
* Paradise #[13290](https://github.com/ParadiseSS13/Paradise/pull/13290): Fixes an exploit with guardian creating items
    * Changes when a flag is set to prevent multi-use exploit
* Paradise #[13293](https://github.com/ParadiseSS13/Paradise/pull/13293): Zeroth law is now above ion laws
    * Changes sort order in `ai_laws.dm`; now zeroth comes first
    * Modifies AI Law interface to reflect new law ordering
    * Cleans up trailing whitespace and newline endings in files
* Paradise #[13187](https://github.com/ParadiseSS13/Paradise/pull/13187): Increases distance of accelerated particles back to how they were
    * Increases the `movement_range` of accelerated particles
* Paradise #[13006](https://github.com/ParadiseSS13/Paradise/pull/13006): Increases the defib timer back to 5 minutes
    * Changes `DEFIB_TIME_LIMIT` from 2 minutes to 5 minutes
* Paradise #[13302](https://github.com/ParadiseSS13/Paradise/pull/13302): Deconstructing chem dispensers no longer deletes the beaker and power cell
    * Fixes the bug by moving the code to detach the beaker and cell to the right place
* Paradise #[13283](https://github.com/ParadiseSS13/Paradise/pull/13283): Makes special cams not runtime on spawn
    * Modifies `code/game/machinery/camera/presets.dm` to use `Initialize` instead of `New`
