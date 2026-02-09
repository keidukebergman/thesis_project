extends XRCamera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_key_pressed(KEY_W)):
		position.z -= delta*0.5
	if(Input.is_key_pressed(KEY_S)):
		position.z += delta*0.5
	if(Input.is_key_pressed(KEY_A)):
		position.x -= delta*0.5
	if(Input.is_key_pressed(KEY_D)):
		position.x += delta*0.5
