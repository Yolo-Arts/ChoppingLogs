extends Bulletin

@export var name_label : Label
@export var health_bar : ProgressBar

func initialize(object : HittableObjectTemplate) -> void:
	name_label.text = object.name
	health_bar.max_value = object.attributes.max_health
	health_bar.value = object.current_health
	
	if object.has_signal(&"health_changed"):
		object.health_changed.connect(_on_health_changed)

func _on_health_changed(new_value: float) -> void:
	health_bar.value = new_value
