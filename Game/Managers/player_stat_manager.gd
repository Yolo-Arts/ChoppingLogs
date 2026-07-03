extends Node
class_name PlayerStats

@export_group("Upgrades")
@export var base_inventory_size: int = 3
@export var base_max_weight: float = 5000.0
@export var base_normal_speed: float = 4.0
@export var base_sprint_speed: float = 16.0
@export var base_axe_damage_bonus: float = 15.0
@export var base_axe_speed_bonus: float = 5.0

@export_group("Weight")
@export var weight : float = 0
var player_speed_with_weight_modifier: float = 1.0

var inventory_size: int:
	get: return get_inventory_size_at_level(UpgradeConfig.upgrades[UpgradeConfig.Keys.BackPack])

var max_weight : float:
	get: return base_max_weight

var normal_speed: float:
	get: return get_normal_speed_at_level(UpgradeConfig.upgrades[UpgradeConfig.Keys.SprintSpeed])

var sprint_speed: float:
	get: return get_sprint_speed_at_level(UpgradeConfig.upgrades[UpgradeConfig.Keys.SprintSpeed])

var axe_damage_bonus: float:
	get: return get_axe_damage_at_level(UpgradeConfig.upgrades[UpgradeConfig.Keys.ChopDamage])

var axe_speed_bonus: float:
	get: return get_axe_speed_at_level(UpgradeConfig.upgrades[UpgradeConfig.Keys.AxeSpeed])

@export_group("Stats")
@export var health: float = 100
@export var money: float = 0

@export var axe_damage_mult_bonus: float = 1.0
@export var axe_range: float = 1.5
@export var axe_crit_chance: float = 0.0	
@export var axe_crit_damage: float = 0.0

@export_group("Fire Slash")
@export var unlocked_fire_slash: bool = false
@export var fire_slash_damage: float = 50.0
@export var fire_slash_cooldown: float = 20.0
@export var fire_slash_pierce_count: int = 1

func get_inventory_size_at_level(lvl: int) -> int:
	return base_inventory_size + (lvl * 1)

func get_normal_speed_at_level(lvl: int) -> float:
	return base_normal_speed + (lvl * 0.4)

func get_sprint_speed_at_level(lvl: int) -> float:
	return base_sprint_speed + (lvl * 2.4)

func get_axe_damage_at_level(lvl: int) -> float:
	return base_axe_damage_bonus + (lvl * 10.0)

func get_axe_speed_at_level(lvl: int) -> float:
	return base_axe_speed_bonus + (lvl * 0.1)

func _ready() -> void:
	EventSystem.WEP_unlock_fire_slash.connect(func(): unlocked_fire_slash = true, CONNECT_ONE_SHOT)
	EventSystem.UPG_increase_fire_slash_damage.connect(func(increase): fire_slash_damage += increase)
	EventSystem.UPG_increase_fire_slash_fire_rate.connect(func(increase): fire_slash_cooldown -= increase)
	EventSystem.UPG_increase_fire_slash_pierce_count.connect(func(increase): fire_slash_pierce_count += increase)
	
	EventSystem.UPG_increase_axe_range.connect(func(increase): 
		axe_range += increase
		EventSystem.AXE_update_hit_marker_position.emit()
	)
	EventSystem.UPG_increase_crit_chance.connect(increase_player_crit_chance)
	EventSystem.UPG_increase_crit_damage.connect(increase_player_crit_damage)


func increase_player_crit_chance(crit_chance: float):
	axe_crit_chance += crit_chance
	print(axe_crit_chance)

func increase_player_crit_damage(crit_dmg: float):
	axe_crit_damage += crit_dmg
	print(axe_crit_damage)
