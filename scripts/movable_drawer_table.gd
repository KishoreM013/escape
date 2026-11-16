extends Node3D

@export var distance := 0.6                 # how far to slide, in meters
@export var direction := Vector3.FORWARD    # FORWARD = -Z, use BACK if it slides the wrong way
@export var move_time := 0.6

var start_pos := Vector3.ZERO
var is_out := false
var player_near := false
var tween: Tween

@onready var table: Node3D = $drawer_table
@onready var area: Area3D = $Area3D

func reset_state() -> void:
	if tween:
		tween.kill()
	is_out = false
	table.position = start_pos

func _ready() -> void:
	add_to_group("resettable")
	start_pos = table.position
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_near = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_near = false


func _unhandled_input(event: InputEvent) -> void:
	if player_near and event.is_action_pressed("move"):
		toggle()


func toggle() -> void:
	is_out = not is_out
	var target := start_pos + direction.normalized() * distance if is_out else start_pos
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(table, "position", target, move_time) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
