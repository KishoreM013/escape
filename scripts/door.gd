extends Node3D

@export var open_angle := 90.0
@export var open_time := 0.5

var is_open := false
var player_near := false
var tween: Tween


func _ready() -> void:
	add_to_group("resettable")
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_near = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_near = false


func _unhandled_input(event: InputEvent) -> void:
	if player_near and event.is_action_pressed("interact"):
		toggle()


func toggle() -> void:
	is_open = not is_open
	if tween:
		tween.kill()
	tween = create_tween()
	var target := deg_to_rad(open_angle) if is_open else 0.0
	tween.tween_property($hinge, "rotation:y", target, open_time) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func reset_state() -> void:
	if tween:
		tween.kill()
	is_open = false
	$hinge.rotation.y = 0.0
