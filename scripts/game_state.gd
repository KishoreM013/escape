extends Node

signal keys_changed(count: int)
signal all_keys_collected

const KEYS_NEEDED := 5
var keys := 0


func add_key() -> void:
	keys += 1
	keys_changed.emit(keys)
	if keys >= KEYS_NEEDED:
		all_keys_collected.emit()


func reset() -> void:
	keys = 0
	keys_changed.emit(keys)
