# paradise-upstream.md
Changelog for changes we incorporate from upstream (Paradise Station).

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
