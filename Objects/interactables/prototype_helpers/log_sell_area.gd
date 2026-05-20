extends Area3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	EventSystem.UPG_increase_sell_radius.connect(increase_sell_radius)

# Sells logs automatically
func _on_body_entered(body: Node3D) -> void:
	EventSystem.MON_sell_all_items.emit()

func increase_sell_radius(increase_amount: float):
	collision_shape_3d.scale += Vector3(increase_amount, 0, increase_amount)
