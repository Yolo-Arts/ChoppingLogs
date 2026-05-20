extends Area3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
var can_sell: bool = false

func _ready() -> void:
	EventSystem.UPG_increase_sell_radius.connect(increase_sell_radius)
	EventSystem.MON_check_if_can_sell.connect(check_if_can_sell)

func check_if_can_sell():
	print("Can sell: ", can_sell)
	if can_sell:
		EventSystem.MON_sell_all_items.emit()

func increase_sell_radius(increase_amount: float):
	collision_shape_3d.scale += Vector3(increase_amount, 0, increase_amount)


# Sells logs automatically
func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		can_sell = true
		EventSystem.MON_sell_all_items.emit()

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		can_sell = false
