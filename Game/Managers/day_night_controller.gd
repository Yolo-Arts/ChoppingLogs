extends Node

@export var startTime: float = 6.0
@export var dayLengthInSeconds: float = 96.0

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

func _ready() -> void:
	top_colors = [morningColorTop, dayColorTop, afternoonColorTop, nightColorTop]
	horizon_colors = [morningColorHorizon, dayColorHorizon, afternoonColorHorizon, nightColorHorizon]
	sun_colors = [morningSunColor, daySunColor, afternoonSunColor, nightSunColor] 
	
	_setup_duration()
	_set_initial_time()

func _setup_duration() -> void:
	var duration_multiplier = dayLengthInSeconds / 24.0
	animation_player.speed_scale = 1.0 / duration_multiplier

func _set_initial_time() -> void:
	animation_player.play("day_and_night")
	animation_player.seek(startTime, true)

func _process(_delta: float) -> void:
	_update_sky_cycle()
	_update_time_label()

func _update_sky_cycle() -> void:
	var current_time = animation_player.current_animation_position
	
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

func _update_world_lighting(current_time: float, horizon_color: Color) -> void:
	if current_time > 20.0 or current_time < 6.0:
		# Night time: 
		sun_light.light_energy = lerp(sun_light.light_energy, 0.1, 0.1)
		#sun_light.light_color = nightColorHorizon
	else:
		# Day time: 
		sun_light.light_energy = lerp(sun_light.light_energy, 1.0, 0.1)
		#sun_light.light_color = horizon_color
	sun_light.light_color = horizon_color

func _update_time_label() -> void:
	var current_time = animation_player.current_animation_position
	
	var hours: int = int(current_time)
	var minutes: int = int((current_time - hours) * 60)
	
	var period: String = "AM"
	if hours >= 12:
		period = "PM"
	
	var hours_12: int = hours % 12
	if hours_12 == 0:
		hours_12 = 12 
		
	var new_time = "%d:%02d %s" % [hours_12, minutes, period]
	EventSystem.HUD_update_time.emit(new_time)
