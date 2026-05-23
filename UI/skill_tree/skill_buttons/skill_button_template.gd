extends TextureButton
class_name SkillNode
 
@onready var panel = $Panel
@onready var label = %Label
@onready var line_2d = $Line2D

@export var upgrade_key: SkillTreeConfig.Keys
@export var max_level: int
@export var stat_increase: float
@export var level_requirement_to_reveal: int = 3

var level : int = 0:
	set(value):
		level = value
		label.text = str(level) + "/" + str(max_level)

func _ready():
	level = SkillTreeConfig.upgrades[upgrade_key] 
	if level > 0:
		activate()
	label.text = str(level) + "/" + str(max_level)
	if get_parent() is SkillNode:
		line_2d.clear_points()
		
		var my_center = global_position + (size / 2)
		var parent_center = get_parent().global_position + (get_parent().size / 2)
		
		line_2d.add_point(line_2d.to_local(my_center))
		line_2d.add_point(line_2d.to_local(parent_center))


func _on_pressed():
	level = min( level+1 , max_level)
	SkillTreeConfig.upgrades[upgrade_key] += 1
	var my_center = global_position + (size / 2)
	
	EventSystem.SKL_update_panning.emit(my_center)
	activate()
	
	line_2d.default_color = Color(1, 1, 0.24705882370472)
	
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.MenuBtnPressed)
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and SkillTreeConfig.upgrades[upgrade_key] == level_requirement_to_reveal:
			skill.visible = true
			skill.disabled = false
	
	if level >= max_level:
		print("reached max level")
		self_modulate = Color(1, 1, 0.24705882370472)
		disabled = true
		return

func activate():
	panel.show_behind_parent = true
	panel.visible = false
	
	line_2d.default_color = Color(1, 1, 0.24705882370472)
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and SkillTreeConfig.upgrades[upgrade_key] >= level_requirement_to_reveal:
			skill.show_behind_parent = true
			skill.visible = true
			skill.disabled = false
	
	if level >= max_level:
		print("reached max level")
		self_modulate = Color(1, 1, 0.24705882370472)
		disabled = true


func _on_mouse_entered() -> void:
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SkillTreeToolTip, self)

func _on_mouse_exited() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.SkillTreeToolTip)
