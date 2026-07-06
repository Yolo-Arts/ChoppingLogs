extends Node
class_name PlayerStats

@export_group("Upgrades")
@export var base_inventory_size: int = 3
@export var base_max_weight: float = 5000.0
@export var base_normal_speed: float = 4.0
const base_sprint_multi: float = 4.0
@export var sprint_multi_per_lvl: float = 0.1
@export var base_sprint_stamina: float = 1.0 #seconds
@export var stamina_per_lvl: float = 1
@export var base_axe_damage_bonus: float = 1.0
@export var base_axe_speed_bonus: float = 1.0

@export_group("Weight")
@export var weight : float = 0
var player_speed_with_weight_modifier: float = 1.0

@export_group("Stats")
@export var health: float = 100
@export var money: float = 0
@export var axe_damage_mult_bonus: float = 1.0
@export var axe_range: float = 1.5
@export var axe_crit_chance: float = 0.0:
	get:
		return (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_CHANCE_1] * 10.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_CHANCE_2] * 2.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_CHANCE_3] * 5.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_CHANCE_4] * 10.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_CHANCE_5] * 10.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_CHANCE_6] * 10.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_CHANCE_7] * 10.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_CHANCE_8] * 10.0) 
@export var axe_crit_damage: float = 100.0:
	get:
		return 100 + (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_DAMAGE_1] * 5.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_DAMAGE_2] * 10.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_DAMAGE_3] * 25.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_DAMAGE_4] * 50.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_CRIT_DAMAGE_5] * 100.0) 

@export_group("Fire Slash")
@export var unlocked_fire_slash: bool = false:
	get:
		return true if SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_UNLOCK] else false
@export var fire_slash_damage: float = 500.0:
	get:
		return 500 * ( max((SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_DMG_INC_1] * 2), 1) \
		#* max((SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_DMG_INC_2] * 5), 1) \
		* pow(5, SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_DMG_INC_2]) \
		* max((SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_DMG_INC_3] * 8), 1) )
@export var fire_slash_cooldown: float = 10.0:
	get:
		return 10.0 - ((SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_RATE_1] * 2.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_RATE_2] * 2.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_RATE_3] * 3.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_RATE_4] * 1.0) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_RATE_5] * 1.0) )
@export var fire_slash_pierce_count: int = 1:
	get:
		return 1 \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_PIERCE_1]) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_PIERCE_2]) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_PIERCE_3]) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_PIERCE_4]) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_PIERCE_5]) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.FIRE_SLASH_PIERCE_6]) 
		

var axe_damage_bonus: float:
	get: return get_axe_damage_at_level(UpgradeConfig.upgrades[UpgradeConfig.Keys.ChopDamage])

var axe_speed_bonus: float:
	get: return get_axe_speed_at_level(UpgradeConfig.upgrades[UpgradeConfig.Keys.AxeSpeed])

var sprint_speed: float:
	get: return normal_speed * get_sprint_multi_at_level(UpgradeConfig.upgrades[UpgradeConfig.Keys.SprintSpeed])

var max_sprint_stamina: float:
	get: return get_sprint_stamina_at_level(UpgradeConfig.upgrades[UpgradeConfig.Keys.SprintStamina]) 

var normal_speed: float:
	get: return base_normal_speed#Change this back if desired, would just need to change how sprint speed upgrade gets displayed

var inventory_size: int:
	get: return get_inventory_size_at_level(UpgradeConfig.upgrades[UpgradeConfig.Keys.BackPack])

var max_weight : float:
	get: return base_max_weight

func get_axe_damage_at_level(lvl: int) -> float:
	return base_axe_damage_bonus + (lvl * max(1, (1 * 
	(
		(SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_DAMAGE_1] * 2) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_DAMAGE_2] * 3) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_DAMAGE_3] * 5) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_DAMAGE_4] * 10) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_DAMAGE_5] * 30) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_DAMAGE_6] * 50) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.AXE_DAMAGE_7] * 400) 
	))))

func get_axe_speed_at_level(lvl: int) -> float:
	return base_axe_speed_bonus + (lvl * 0.2)

func get_normal_speed_at_level(lvl: int) -> float:
	return base_normal_speed + (lvl * 0.4)

func get_sprint_multi_at_level(lvl: int) -> float:
	return base_sprint_multi + (lvl * sprint_multi_per_lvl)
	
func get_sprint_stamina_at_level(lvl: int) -> float:
	return base_sprint_stamina + (stamina_per_lvl * lvl)

func get_inventory_size_at_level(lvl: int) -> int:
	return base_inventory_size + (lvl * max(1, (1 * 
	(
		(SkillTreeConfig.upgrades[SkillTreeConfig.Keys.INVENTORY_SLOTS_PER_LEVEL_1] * 1) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.INVENTORY_SLOTS_PER_LEVEL_2] * 2) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.INVENTORY_SLOTS_PER_LEVEL_3] * 5) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.INVENTORY_SLOTS_PER_LEVEL_4] * 10) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.INVENTORY_SLOTS_PER_LEVEL_4] * 20) \
		+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.INVENTORY_SLOTS_PER_LEVEL_4] * 50) \
	))))

func _ready() -> void:
	EventSystem.WEP_unlock_fire_slash.connect(func(): unlocked_fire_slash = true, CONNECT_ONE_SHOT)
	EventSystem.UPG_increase_fire_slash_damage.connect(func(increase): fire_slash_damage += increase)
	EventSystem.UPG_increase_fire_slash_fire_rate.connect(func(increase): fire_slash_cooldown -= increase)
	EventSystem.UPG_increase_fire_slash_pierce_count.connect(func(increase): fire_slash_pierce_count += increase)
	
	EventSystem.UPG_increase_axe_range.connect(func(increase): 
		axe_range += increase
		EventSystem.AXE_update_hit_marker_position.emit()
	)
	
	EventSystem.TRE_tree_cut.connect(func(): 
		if SkillTreeConfig.upgrades[SkillTreeConfig.Keys.TIME_TREES] > 0:
			EventSystem.HUD_change_countdown.emit(0.1) #TODO: Refactor once skill tree system is more solidified.
	)
	#EventSystem.UPG_increase_crit_chance.connect(increase_player_crit_chance)
	#EventSystem.UPG_increase_crit_damage.connect(increase_player_crit_damage)


#func increase_player_crit_chance(crit_chance: float):
	#axe_crit_chance += crit_chance
	#print(axe_crit_chance)
#
#func increase_player_crit_damage(crit_dmg: float):
	#axe_crit_damage += crit_dmg
	#print(axe_crit_damage)
