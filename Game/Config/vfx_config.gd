class_name VFXConfig

enum Keys {
	HitParticlesWood,
}

const FILE_PATHS := {
	Keys.HitParticlesWood: "res://Particles/hit_particles_wood.tscn",
}

static func get_vfx(key:Keys) -> PackedScene:
	return load(FILE_PATHS.get(key))
