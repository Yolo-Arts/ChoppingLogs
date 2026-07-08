extends Interactable

@export var prestige_points: float = 5000

func start_interaction() -> void:
	EventSystem.PRE_change_prestige_points_value.emit(prestige_points)
