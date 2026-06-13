extends Interactable

func start_interaction() -> void:
	# TODO: How much should each interaction increase crit_chance
	EventSystem.UPG_increase_crit_chance.emit(5.0)
