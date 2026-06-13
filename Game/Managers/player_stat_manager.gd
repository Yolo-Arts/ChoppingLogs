extends Node
class_name PlayerStats

@export_group("Weight")
@export var weight : float = 0
@export var max_weight : float = 5
var player_speed_with_weight_modifier: float = 1.0

@export_group("Movement")
@export var normal_speed := 3.0
@export var sprint_speed := 5.0
@export var sprint_energy: float = 100.0

@export_group("Stats")
@export var health: float = 100
@export var money: float = 0

@export_group("Axe")
@export var axe_speed_bonus: float = 0.0
@export var axe_damage_bonus: float = 0.0
@export var axe_damage_mult_bonus: float = 1.0
@export var axe_range: float = 1.5
# TODO: Set initial values for crit chance/dmg
@export var axe_crit_chance: float = 0.0	# this is percent, i.e. 100 -> 100%.
@export var axe_crit_damage: float = 0.0

@export_group("Fire Slash")
@export var unlocked_fire_slash: bool = false
@export var fire_slash_damage: float = 50.0
@export var fire_slash_cooldown: float = 20.0
@export var fire_slash_pierce_count: int = 1


func _ready() -> void:
	EventSystem.AXE_increase_axe_speed.connect(increase_axe_speed_bonus)
	EventSystem.AXE_increase_axe_damage.connect(increase_axe_damage_bonus)
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

func increase_axe_speed_bonus(axe_bonus: float):
	axe_speed_bonus += axe_bonus

func increase_axe_damage_bonus(axe_bonus: float):
	axe_damage_bonus += axe_bonus

func increase_player_normal_speed(normal_speed_bonus: float):
	normal_speed += normal_speed_bonus

func increase_player_sprint_speed(sprint_speed_bonus: float):
	sprint_speed += sprint_speed_bonus

func increase_player_crit_chance(crit_chance: float):
	axe_crit_chance += crit_chance
	print(axe_crit_chance)

func increase_player_crit_damage(crit_dmg: float):
	axe_crit_damage += crit_dmg
	print(axe_crit_damage)