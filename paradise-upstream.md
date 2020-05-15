# paradise-upstream.md
Changelog for changes we incorporate from upstream (Paradise Station).

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
