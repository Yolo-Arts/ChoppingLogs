extends Node

@export var baseCountdownDuration: float = 40.0
@export var startHour: float = 6.0         
@export var endHour: float = 22.0          

@export_group("Sun Light")
@export var sun_light: DirectionalLight3D

@export_group("Morning Colors")
@export var morningColorTop: Color = Color("5897fa")
@export var morningColorHorizon: Color = Color("d3916b")
@export var morningSunColor: Color = Color("fce1ba") 

@export_group("Day Colors")
@export var dayColorTop: Color = Color("1f6ddf")
@export var dayColorHorizon: Color = Color("56a9f5")
@export var daySunColor: Color = Color("ffffff") 

@export_group("Afternoon Colors")
@export var afternoonColorTop: Color = Color("3d6fcd")
@export var afternoonColorHorizon: Color = Color("e98174")
@export var afternoonSunColor: Color = Color("fca677") 

@export_group("Night Colors")
@export var nightColorTop: Color = Color("090e14")
@export var nightColorHorizon: Color = Color("010049")
@export var nightSunColor: Color = Color("aec3de") 

@onready var world_environment: WorldEnvironment = %WorldEnvironment
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var time_keys: Array[float] = [6.0, 8.0, 18.0, 20.0]
var top_colors: Array[Color] = []
var horizon_colors: Array[Color] = []
var sun_colors: Array[Color] = []

var countdownDuration: float
var time_remaining: float
var is_timer_over: bool = false

func _ready() -> void:
	top_colors = [morningColorTop, dayColorTop, afternoonColorTop, nightColorTop]
	horizon_colors = [morningColorHorizon, dayColorHorizon, afternoonColorHorizon, nightColorHorizon]
	sun_colors = [morningSunColor, daySunColor, afternoonSunColor, nightSunColor] 
	
	countdownDuration = calc_countdown()
	time_remaining = countdownDuration
	
	EventSystem.HUD_change_countdown.connect(change_countdown)
	
	# Start the animation but keep it paused; we will drive its position manually
	animation_player.play("day_and_night")
	animation_player.pause()
	
	_update_sky_cycle()
	_update_time_label()

func _process(delta: float) -> void:
	if is_timer_over:
		return

	change_countdown(-delta)
	_update_sky_cycle()

func _update_sky_cycle() -> void:
	var progress = 1.0 - (time_remaining / countdownDuration)
	
	var current_time = lerp(startHour, endHour, progress)
	
	animation_player.seek(current_time, true)
	
	var idx_current = 0
	var idx_next = 0
	
	if current_time >= time_keys[3] or current_time < time_keys[0]:
		idx_current = 3 # Night
		idx_next = 0    # Morning
	else:
		for i in range(time_keys.size() - 1):
			if current_time >= time_keys[i] and current_time < time_keys[i+1]:
				idx_current = i
				idx_next = i + 1
				break
				
	var time_start = time_keys[idx_current]
	var time_end = time_keys[idx_next]
	
	var elapsed = current_time - time_start
	if elapsed < 0: elapsed += 24.0
		
	var duration = time_end - time_start
	if duration < 0: duration += 24.0
		
	var t = elapsed / duration
	
	var blended_top = top_colors[idx_current].lerp(top_colors[idx_next], t)
	var blended_horizon = horizon_colors[idx_current].lerp(horizon_colors[idx_next], t)
	var blended_sun = sun_colors[idx_current].lerp(sun_colors[idx_next], t) 
	
	var sky_mat = world_environment.environment.sky.sky_material
	if sky_mat:
		sky_mat.sky_top_color = blended_top
		sky_mat.sky_horizon_color = blended_horizon
		sky_mat.ground_bottom_color = blended_top
		sky_mat.ground_horizon_color = blended_horizon

	if sun_light:
		_update_world_lighting(current_time, blended_sun)

func calc_countdown() -> float:
	var result: float = baseCountdownDuration
	var i: int = SkillTreeConfig.Keys.INC_TIME_1
	while i <= SkillTreeConfig.Keys.INC_TIME_9:
		result += SkillTreeConfig.upgrades[i] * 60#fine since they're all +1min
		i += 1
	return result
	
func change_countdown(amt: float) -> void:
	time_remaining += amt

	if time_remaining <= 0:
		time_remaining = 0
		is_timer_over = true
		end_day()
	_update_time_label()

func _update_world_lighting(current_time: float, horizon_color: Color) -> void:
	if current_time > 20.0 or current_time < 6.0:
		# Night time: 
		sun_light.light_energy = lerp(sun_light.light_energy, 0.1, 0.1)
	else:
		# Day time: 
		sun_light.light_energy = lerp(sun_light.light_energy, 1.0, 0.1)
	sun_light.light_color = horizon_color

func _update_time_label() -> void:
	@warning_ignore("integer_division")#purposely truncated
	var minutes: int = int(time_remaining) / 60
	var seconds: int = int(time_remaining) % 60
	
	var new_time = "%d:%02d" % [minutes, seconds]
	EventSystem.HUD_update_time.emit(new_time, int(time_remaining))

func end_day() -> void:
	print("Day is over!")
	var met_quota = EventSystem.QUO_check_quota.call()
	print("Met quota:", met_quota)
	#if met_quota:
		#EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.PlaceholderDayEnd)
	#else:
		#EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.LoseScreen)
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.ResultsScreen)
