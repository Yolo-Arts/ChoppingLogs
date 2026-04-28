extends Area3D

signal register_hit


@export var hit_audio_key := SFXConfig.Keys.MenuBtnPressed
@export var hit_particles_key := VFXConfig.Keys.HitParticlesWood


func take_hit(weapon_item_resource) -> void:
	register_hit.emit(weapon_item_resource)
	EventSystem.SFX_play_dynamic_sfx.emit(hit_audio_key, global_position)
