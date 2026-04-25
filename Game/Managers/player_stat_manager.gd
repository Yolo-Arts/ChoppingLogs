extends Node
class_name PlayerStats

@export_group("Weight")
@export var weight : float = 0
@export var max_weight : float = 5
var player_speed_with_weight_modifier: float = 1.0

@export_group("Movement")
@export var normal_speed := 3.0
@export var sprint_speed := 5.0
