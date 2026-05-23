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
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)


func _on_pressed():
	level = min( level+1 , max_level)
	SkillTreeConfig.upgrades[upgrade_key] += 1
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
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and SkillTreeConfig.upgrades[upgrade_key] >= level_requirement_to_reveal:
			skill.visible = true
			skill.disabled = false
	
	if level >= max_level:
		print("reached max level")
		self_modulate = Color(1, 1, 0.24705882370472)
		disabled = true
