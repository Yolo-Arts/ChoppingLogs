extends Node

@export var quota_base: int = 50
@export var quota: int = 50
@export var quota_level: float = 1.0

func _ready() -> void:
	EventSystem.QUO_increase_quota_amount.connect(update_quota_amount)
	EventSystem.QUO_reset_quota.connect(reset_quota)
	print("Quota is: ", quota)
	EventSystem.QUO_get_quota_amount = func(): return quota
	EventSystem.QUO_update_quota_text.emit()
	
	EventSystem.QUO_check_quota = func() -> bool: 
		if EventSystem.MON_get_player_money.call() >= quota: 
			return true 
		else: 
			return false

func update_quota_amount():
	quota_level += 0.2
	quota = pow(quota_base, quota_level)
	EventSystem.QUO_update_quota_text.emit()
	print("Quota is: ", quota)

func reset_quota():
	quota_base = 50
	quota_level = 1.0
	quota = quota_base
	EventSystem.QUO_update_quota_text.emit()
	print("Quota is: ", quota)
