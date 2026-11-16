extends Area3D


func _ready() -> void:
	add_to_group("resettable")
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		GameState.add_key()
		hide()
		set_deferred("monitoring", false)


func reset_state() -> void:
	show()
	set_deferred("monitoring", true)
