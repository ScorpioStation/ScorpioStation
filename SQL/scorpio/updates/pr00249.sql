-- This part written by AffectedArc07 ------------------------------------------
ALTER TABLE player ADD COLUMN toggles_2 INT NULL DEFAULT '0' AFTER toggles;

UPDATE player SET toggles_2 = toggles_2 + 1 WHERE randomslot = 1;
UPDATE player SET toggles_2 = toggles_2 + 2 WHERE nanoui_fancy = 1;
UPDATE player SET toggles_2 = toggles_2 + 4 WHERE show_ghostitem_attack = 1;
UPDATE player SET toggles_2 = toggles_2 + 8 WHERE windowflashing = 1;
UPDATE player SET toggles_2 = toggles_2 + 16 WHERE ghost_anonsay = 1;
UPDATE player SET toggles_2 = toggles_2 + 32 WHERE afk_watch = 1;

-- This part written by blinkdog -----------------------------------------------
CREATE TABLE player_preferences (
  id int NOT NULL AUTO_INCREMENT,
  player_id int NOT NULL,
  pref_key varchar(64) NOT NULL,
  pref_val mediumtext NOT NULL,
  PRIMARY KEY (id),
  INDEX index_player_preferences_player_id (player_id),
  FOREIGN KEY (player_id) REFERENCES player(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'atklog', atklog
FROM player WHERE atklog IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'be_special', be_role
FROM player WHERE be_role IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'chat_on_map', chat_on_map
FROM player WHERE chat_on_map IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'clientfps', clientfps
FROM player WHERE clientfps IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'default_slot', default_slot
FROM player WHERE default_slot IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'max_chat_length', max_chat_length
FROM player WHERE max_chat_length IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'ooccolor', ooccolor
FROM player WHERE ooccolor IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'parallax', parallax
FROM player WHERE parallax IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'see_chat_non_mob', see_chat_non_mob
FROM player WHERE see_chat_non_mob IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'sound', sound
FROM player WHERE sound IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'toggles', toggles
FROM player WHERE toggles IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'toggles2', toggles_2
FROM player WHERE toggles_2 IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'UI_style', UI_style
FROM player WHERE UI_style IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'UI_style_alpha', UI_style_alpha
FROM player WHERE UI_style_alpha IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'UI_style_color', UI_style_color
FROM player WHERE UI_style_color IS NOT NULL;

INSERT INTO player_preferences (player_id, pref_key, pref_val)
SELECT id, 'volume', volume
FROM player WHERE volume IS NOT NULL;

-- This part written by blinkdog -----------------------------------------------
CREATE TABLE character_attributes (
  id int NOT NULL AUTO_INCREMENT,
  character_id int NOT NULL,
  attr_key varchar(64) NOT NULL,
  attr_val mediumtext NOT NULL,
  PRIMARY KEY (id),
  INDEX index_character_attributes_character_id (character_id),
  FOREIGN KEY (character_id) REFERENCES characters(id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'age', age
FROM characters WHERE age IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'alt_head', alt_head_name
FROM characters WHERE alt_head_name IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'alternate_option', alternate_option
FROM characters WHERE alternate_option IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'ark_soft_relation', ark_soft_relation
FROM characters WHERE ark_soft_relation IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'autohiss_mode', autohiss
FROM characters WHERE autohiss IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'b_type', b_type
FROM characters WHERE b_type IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'backbag', backbag
FROM characters WHERE backbag IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'be_random_name', name_is_always_random
FROM characters WHERE name_is_always_random IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'body_accessory', body_accessory
FROM characters WHERE body_accessory IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'disabilities', disabilities
FROM characters WHERE disabilities IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'e_colour', eye_colour
FROM characters WHERE eye_colour IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'f_colour', facial_hair_colour
FROM characters WHERE facial_hair_colour IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'f_sec_colour', secondary_facial_hair_colour
FROM characters WHERE secondary_facial_hair_colour IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'f_style', facial_style_name
FROM characters WHERE facial_style_name IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'flavor_text', flavor_text
FROM characters WHERE flavor_text IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'gen_record', gen_record
FROM characters WHERE gen_record IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'gender', gender
FROM characters WHERE gender IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'h_colour', hair_colour
FROM characters WHERE hair_colour IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'h_sec_colour', secondary_hair_colour
FROM characters WHERE secondary_hair_colour IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'h_style', hair_style_name
FROM characters WHERE hair_style_name IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'ha_style', head_accessory_style_name
FROM characters WHERE head_accessory_style_name IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'hacc_colour', head_accessory_colour
FROM characters WHERE head_accessory_colour IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_engsec_high', job_engsec_high
FROM characters WHERE job_engsec_high IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_engsec_low', job_engsec_low
FROM characters WHERE job_engsec_low IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_engsec_med', job_engsec_med
FROM characters WHERE job_engsec_med IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_karma_high', job_karma_high
FROM characters WHERE job_karma_high IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_karma_low', job_karma_low
FROM characters WHERE job_karma_low IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_karma_med', job_karma_med
FROM characters WHERE job_karma_med IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_medsci_high', job_medsci_high
FROM characters WHERE job_medsci_high IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_medsci_low', job_medsci_low
FROM characters WHERE job_medsci_low IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_medsci_med', job_medsci_med
FROM characters WHERE job_medsci_med IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_support_high', job_support_high
FROM characters WHERE job_support_high IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_support_low', job_support_low
FROM characters WHERE job_support_low IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'job_support_med', job_support_med
FROM characters WHERE job_support_med IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'language', language
FROM characters WHERE language IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'loadout_gear', gear
FROM characters WHERE gear IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'm_colours', marking_colours
FROM characters WHERE marking_colours IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'm_styles', marking_styles
FROM characters WHERE marking_styles IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'med_record', med_record
FROM characters WHERE med_record IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'metadata', OOC_Notes
FROM characters WHERE OOC_Notes IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'organ_data', organ_data
FROM characters WHERE organ_data IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'player_alt_titles', player_alt_titles
FROM characters WHERE player_alt_titles IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'real_name', real_name
FROM characters WHERE real_name IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'rlimb_data', rlimb_data
FROM characters WHERE rlimb_data IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 's_colour', skin_colour
FROM characters WHERE skin_colour IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 's_tone', skin_tone
FROM characters WHERE skin_tone IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'sec_record', sec_record
FROM characters WHERE sec_record IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'socks', socks
FROM characters WHERE socks IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'species', species
FROM characters WHERE species IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'speciesprefs', speciesprefs
FROM characters WHERE speciesprefs IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'undershirt', undershirt
FROM characters WHERE undershirt IS NOT NULL;

INSERT INTO character_attributes (character_id, attr_key, attr_val)
SELECT id, 'underwear', underwear
FROM characters WHERE underwear IS NOT NULL;

-- This part originally written by AffectedArc07 -------------------------------
-- This part modified by blinkdog for Scorpio ----------------------------------
ALTER TABLE player
DROP COLUMN afk_watch,
DROP COLUMN atklog,
DROP COLUMN be_role,
DROP COLUMN chat_on_map,
DROP COLUMN clientfps,
DROP COLUMN default_slot,
DROP COLUMN ghost_anonsay,
DROP COLUMN max_chat_length,
DROP COLUMN nanoui_fancy,
DROP COLUMN ooccolor,
DROP COLUMN parallax,
DROP COLUMN randomslot,
DROP COLUMN see_chat_non_mob,
DROP COLUMN show_ghostitem_attack,
DROP COLUMN sound,
DROP COLUMN toggles,
DROP COLUMN toggles_2,
DROP COLUMN UI_style,
DROP COLUMN UI_style_alpha,
DROP COLUMN UI_style_color,
DROP COLUMN volume,
DROP COLUMN windowflashing;

ALTER TABLE characters
DROP COLUMN age,
DROP COLUMN alternate_option,
DROP COLUMN alt_head_name,
DROP COLUMN ark_soft_relation,
DROP COLUMN autohiss,
DROP COLUMN backbag,
DROP COLUMN body_accessory,
DROP COLUMN b_type,
DROP COLUMN disabilities,
DROP COLUMN eye_colour,
DROP COLUMN facial_hair_colour,
DROP COLUMN facial_style_name,
DROP COLUMN flavor_text,
DROP COLUMN gear,
DROP COLUMN gender,
DROP COLUMN gen_record,
DROP COLUMN hair_colour,
DROP COLUMN hair_style_name,
DROP COLUMN head_accessory_colour,
DROP COLUMN head_accessory_style_name,
DROP COLUMN job_engsec_high,
DROP COLUMN job_engsec_low,
DROP COLUMN job_engsec_med,
DROP COLUMN job_karma_high,
DROP COLUMN job_karma_low,
DROP COLUMN job_karma_med,
DROP COLUMN job_medsci_high,
DROP COLUMN job_medsci_low,
DROP COLUMN job_medsci_med,
DROP COLUMN job_support_high,
DROP COLUMN job_support_low,
DROP COLUMN job_support_med,
DROP COLUMN language,
DROP COLUMN marking_colours,
DROP COLUMN marking_styles,
DROP COLUMN med_record,
DROP COLUMN name_is_always_random,
DROP COLUMN OOC_Notes,
DROP COLUMN organ_data,
DROP COLUMN player_alt_titles,
DROP COLUMN real_name,
DROP COLUMN rlimb_data,
DROP COLUMN secondary_facial_hair_colour,
DROP COLUMN secondary_hair_colour,
DROP COLUMN sec_record,
DROP COLUMN skin_colour,
DROP COLUMN skin_tone,
DROP COLUMN socks,
DROP COLUMN species,
DROP COLUMN speciesprefs,
DROP COLUMN undershirt,
DROP COLUMN underwear;
