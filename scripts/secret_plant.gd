extends Node3D

@export var push_distance := 1.0
@export var direction := Vector3.RIGHT   # change to LEFT, FORWARD or BACK if needed
@export var move_time := 0.8

var moved := false
var player_near := false

var plant_start := Vector3.ZERO
var tween: Tween

@onready var plant: Node3D = $Plant
@onready var zone: Area3D = $Area3D
@onready var hidden_key: Area3D = get_node_or_null("HiddenKey")


func _ready() -> void:
	plant_start = plant.position
	add_to_group("resettable")
	zone.body_entered.connect(func(b): if b.is_in_group("player"): player_near = true)
	zone.body_exited.connect(func(b): if b.is_in_group("player"): player_near = false)
	if hidden_key:
		hidden_key.visible = false
		hidden_key.monitoring = false


func _unhandled_input(event: InputEvent) -> void:
	if player_near and not moved and event.is_action_pressed("move"):
		move_plant()


func move_plant() -> void:
	moved = true
	var target := plant.position + direction.normalized() * push_distance
	tween = create_tween()
	tween.tween_property(plant, "position", target, move_time) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(_reveal_key)

func reset_state() -> void:
	if tween:
		tween.kill()
	moved = false
	plant.position = plant_start
	if hidden_key:
		hidden_key.hide()
		hidden_key.set_deferred("monitoring", false)

func _reveal_key() -> void:
	if hidden_key:
		hidden_key.visible = true
		hidden_key.monitoring = true
