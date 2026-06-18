extends HittableTree

func _ready() -> void:
	super()

func die() -> void:
	super()
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.WinScreen)
	
func _process(delta: float) -> void:
	regen(delta)
	
#region Regen
const REGEN_TICK_TIME: float = 1.0
var time_accumulation: float = 0.0
func regen(delta : float) -> void:
	if current_health >= attributes.max_health:
		return
		
	time_accumulation +=  delta
	if time_accumulation < REGEN_TICK_TIME:
		return
		
	current_health = clamp(current_health + attributes.regeneration, 0, attributes.max_health)
	
	time_accumulation = (time_accumulation - REGEN_TICK_TIME)
	if current_health >= attributes.max_health:
		time_accumulation = 0
#endregion
