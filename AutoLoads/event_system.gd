extends Node

# BUL -> Bulettin Signals
signal BUL_create_bulletin
signal BUL_destroy_bulletin
signal BUL_destroy_all_bulletins

# PLA -> Player Signals
signal PLA_freeze_player
signal PLA_unfreeze_player

# MON -> Money
signal MON_add_money
signal MON_check_if_can_decrease_money
signal MON_cannot_decrease_money
signal MON_decrease_money
signal MON_money_updated
signal MON_sell_all_items

signal STA_change_stage
var is_transitioning := false

signal MUS_play_music

signal SFX_play_sfx
signal SFX_play_dynamic_sfx

signal HUD_hide_hud
signal HUD_show_hud
signal HUD_reset_hud_elements

# INV -> Inventory signals
signal INV_ask_update_inventory
signal INV_inventory_updated
signal INV_switch_two_inventory_item_indexes
signal INV_delete_item_by_index
signal INV_try_to_pickup_item

# WEI -> Weight signals
signal WEI_weight_changed
signal WEI_update_weight_visual
signal WEI_ask_update_weight_visual
signal WEI_weight_maxed
signal WEI_weight_not_maxed
signal WEI_check_if_weight_maxed
signal WEI_check_if_weight_will_be_maxed
signal WEI_item_weight_too_much
signal WEI_item_weight_not_too_much
signal WEI_cannot_pickup_due_to_weight
signal WEI_cannot_pickup_due_to_space

# UPG -> Upgrade signals
signal UPG_increase_inventory_size
signal UPG_increase_max_weight
#signal UPG_decrease_inventory_size 
#signal UPG_decrease_max_weight

# WEP -> Weapon
signal WEP_unlock_weapon

# SPA -> Spawn
signal SPA_spawn_vfx
signal SPA_spawn_scene
signal SPA_send_spawn_scene_data

# TRE -> Trees
signal TRE_tree_spawned
signal TRE_tree_cut
