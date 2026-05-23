extends TextureButton
class_name SkillNode
 
@onready var panel = $Panel
@onready var label = %Label
@onready var line_2d = $Line2D

@export var max_level: int
@export var stat_increase: float

func _ready():
	label.text = str(level) + "/" + str(max_level)
	if get_parent() is SkillNode:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)
 
var level : int = 0:
	set(value):
		level = value
		label.text = str(level) + "/" + str(max_level)
 
 
 
func _on_pressed():
	level = min( level+1 , max_level)
	if level >= max_level:
		print("reached max level")
		self_modulate = Color(1, 1, 0.24705882370472)
		disabled = true
		return
	panel.show_behind_parent = true
 
	line_2d.default_color = Color(1, 1, 0.24705882370472)
 
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and level == 3:
			skill.visible = true
			skill.disabled = false
