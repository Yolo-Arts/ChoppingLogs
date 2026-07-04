class_name Damage
extends RefCounted

var dmg: float
var crit: bool

func _init(arg_dmg: float, arg_crit: bool):
	dmg = arg_dmg
	crit = arg_crit
