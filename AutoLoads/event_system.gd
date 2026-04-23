extends Node

signal BUL_create_bulletin
signal BUL_destroy_bulletin
signal BUL_destroy_all_bulletins

signal PLA_freeze_player
signal PLA_unfreeze_player

signal STA_change_stage
var is_transitioning := false

signal MUS_play_music

signal SFX_play_sfx
signal SFX_play_dynamic_sfx
