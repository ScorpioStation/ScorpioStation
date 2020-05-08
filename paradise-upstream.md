# paradise-upstream.md
Changelog for changes we incorporate from upstream (Paradise Station).

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
