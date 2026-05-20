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

func _ready() -> void:
	EventSystem.AXE_increase_axe_speed.connect(increase_axe_speed_bonus)
	EventSystem.AXE_increase_axe_damage.connect(increase_axe_damage_bonus)

func increase_axe_speed_bonus(axe_bonus: float):
	axe_speed_bonus += axe_bonus

func increase_axe_damage_bonus(axe_bonus: float):
	axe_damage_bonus += axe_bonus

func increase_player_normal_speed(normal_speed_bonus: float):
	normal_speed += normal_speed_bonus

func increase_player_sprint_speed(sprint_speed_bonus: float):
	sprint_speed += sprint_speed_bonus
