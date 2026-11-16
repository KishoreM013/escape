extends Node3D

@export var blocks := 3.0               # how many blocks to move
@export var block_size := 1.0           # size of one block in meters
@export var direction := Vector3.RIGHT  # sideways, relative to the cupboard
@export var move_time := 1.0            # seconds
@export var need_player_near := true    # false = works from anywhere

var start_pos := Vector3.ZERO
var moved := false
var player_near := false
var tween: Tween

@onready var area: Area3D = $Area3D


func _ready() -> void:
	add_to_group("resettable")
	start_pos = position
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func reset_state() -> void:
	if tween:
		tween.kill()
	moved = false
	position = start_pos

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_near = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_near = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move"):
		if need_player_near and not player_near:
			return
		toggle_move()


func toggle_move() -> void:
	moved = not moved
	var offset := basis * direction.normalized() * blocks * block_size
	var target := start_pos + offset if moved else start_pos
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position", target, move_time) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
