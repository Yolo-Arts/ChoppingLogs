extends Interactable
@export var radius_increase_amount: float = 0.5

func start_interaction() -> void:
    # print("Increased pickup radius by 0.5")
    EventSystem.UPG_increase_pickup_radius.emit(radius_increase_amount)