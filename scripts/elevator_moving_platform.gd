extends Node3D

@export var floor_count := 6        # floors 0 to 5
@export var floor_height := 12      
@export var move_time := 1.0

var current_floor := 0
var player_inside := false
var moving := false
var start_y := 0.0
var tween: Tween

@onready var area: Area3D = $Area3D


func _ready() -> void:
	add_to_group("resettable")
	start_y = position.y
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = false


func _unhandled_input(event: InputEvent) -> void:
	if not player_inside or moving:
		return
	if event.is_action_pressed("lift_up"):
		go_to_floor(current_floor + 1)
	elif event.is_action_pressed("lift_down"):
		go_to_floor(current_floor - 1)


func go_to_floor(target: int) -> void:
	if target < 0 or target >= floor_count:
		return
	current_floor = target
	moving = true
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position:y", start_y + target * floor_height, move_time) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func(): moving = false)

func reset_state() -> void:
	if tween:
		tween.kill()
	moving = false
	current_floor = 0
	position.y = start_y
