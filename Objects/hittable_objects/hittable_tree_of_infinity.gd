extends HittableTree

signal health_changed 
#TODO: Make an eventbus signal if we only ever want to handle one existing "boss"?
#TODO: Name/name change signal?
@export var hp_bar_draw_dist: float = 1000
@export var hp_bar_destroy_dist: float = 2000

var is_hp_bar_drawn: bool = false

func _process(delta: float) -> void:
	regen(delta)
	should_draw_hp_bar()

func die() -> void:
	super()
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.BossHpBar)
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.WinScreen)
	
func _exit_tree() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.BossHpBar)

func _on_hitbox_register_hit(damage) -> void:
	super(damage)
	health_changed.emit(current_health)

func should_draw_hp_bar() -> void: #when choosing "play again" if a player reference is kept, it gets laundered between stage loads and causes a freed obj reference error
	if !is_hp_bar_drawn && global_position.distance_squared_to(get_tree().get_first_node_in_group(&"player").global_position) <= hp_bar_draw_dist:
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.BossHpBar, self)
		is_hp_bar_drawn = true
		return
		
	if is_hp_bar_drawn && global_position.distance_squared_to(get_tree().get_first_node_in_group(&"player").global_position) > hp_bar_destroy_dist:
		EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.BossHpBar)
		is_hp_bar_drawn = false
		return
	
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
	health_changed.emit(current_health)

	time_accumulation -= REGEN_TICK_TIME
	if current_health >= attributes.max_health:#remove this for constant regen timer
		time_accumulation = 0
#endregion
