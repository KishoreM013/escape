extends CanvasLayer

@onready var label: Label = $Label
@onready var win_label: Label = $WinLabel
@onready var restart_button: Button = $RestartButton


func _ready() -> void:
	win_label.hide()
	restart_button.hide()
	GameState.keys_changed.connect(_update)
	GameState.all_keys_collected.connect(_on_won)
	restart_button.pressed.connect(_on_restart)
	_update(GameState.keys)


func _update(count: int) -> void:
	label.text = "Keys: %d / %d" % [count, GameState.KEYS_NEEDED]


func _on_won() -> void:
	win_label.show()
	restart_button.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true


func _on_restart() -> void:
	win_label.hide()
	restart_button.hide()
	GameState.reset()
	get_tree().call_group("resettable", "reset_state")
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
