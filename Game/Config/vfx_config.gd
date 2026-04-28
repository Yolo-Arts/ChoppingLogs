class_name VFXConfig

enum Keys {
	HitParticlesWood,
	HitNumbers,
}

const FILE_PATHS := {
	Keys.HitParticlesWood: "res://Particles/hit_particles_wood.tscn",
	Keys.HitNumbers: "res://Particles/damage_numbers/damage_numbers.tscn",
}

static func get_vfx(key:Keys) -> PackedScene:
	return load(FILE_PATHS.get(key))
