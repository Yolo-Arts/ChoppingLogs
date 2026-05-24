extends TextureButton
class_name SkillNode
 
@onready var panel = $Panel
@onready var line_2d = $Line2D

@export var upgrade_key: SkillTreeConfig.Keys
@export var max_level: int
@export var stat_increase: float
@export var upgrade_cost: int = 10
@export var level_requirement_to_reveal: int = 3
@export var upgrade_name: String = "Upgrade Name"
@export_multiline var description: String = "Description of the upgrade \nDescription must not be longer than 3 lines or else it will deform the tooltip."
@export var price_increase_mult_per_level: float = 1.5

var level : int = 0:
	set(value):
		level = value

func _ready():
	level = SkillTreeConfig.upgrades[upgrade_key] 
	if level > 0:
		activate()
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
	
	#EventSystem.SKL_update_panning.emit(my_center)
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
	var my_center = global_position + (size / 2)
	
	#EventSystem.SKL_update_panning.emit(my_center)
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SkillTreeToolTip, self)

func _on_mouse_exited() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.SkillTreeToolTip)


func _gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)) or \
	   (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT):
		var zoom_node = get_parent()
		while zoom_node != null and zoom_node.name != "ZoomContent":
			zoom_node = zoom_node.get_parent()
			
		if zoom_node:
			zoom_node._gui_input(event)
