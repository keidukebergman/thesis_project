extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Flame.visible = false
	get_parent_node_3d().button_pressed.connect(_on_controller_trigger_pressed)
	get_parent_node_3d().button_released.connect(_on_controller_trigger_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("fire_torch")):
		$Flame.visible = true
	if(Input.is_action_just_released("fire_torch")):
		$Flame.visible = false

func _on_controller_trigger_pressed(button_name):
		$Flame.visible = true

func _on_controller_trigger_released(button_name):
		$Flame.visible = false
