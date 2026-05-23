extends SkillNode
@export var texture: Texture2D

func _ready():
	if texture:
		texture_normal = texture
	super()

func _on_pressed():
	print("Axe Upgrade Pressed!")
	super()
