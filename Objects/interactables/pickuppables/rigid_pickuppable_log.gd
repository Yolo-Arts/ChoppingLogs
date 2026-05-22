extends RigidBody3D
class_name PickuppableLog

@onready var pickuppable_component: Pickuppable = $Area3D

func start_interaction() -> void:
	if pickuppable_component:
		pickuppable_component.start_interaction()

func _ready() -> void:
	sleeping_state_changed.connect(_on_sleeping_state_changed)

func _on_sleeping_state_changed() -> void:
	if sleeping:
		freeze = true
