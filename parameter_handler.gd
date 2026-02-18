extends Node
class_name ParameterHandler

@export var resolution_scale:int = 1
@export var jitter_scale:int = 1
var z_depth:float = 75
var lod_cascades:int = 4
var lod_distance:float = 10
@export var color_depth:int = 24
@export var do_affine_mapping:bool = true
@onready var overlay_compositor = preload("res://Scripts/Shaders/ps1_compositor.tres")

@export var resolution_slider:HSlider
@export var jitter_slider:HSlider
@export var color_slider:HSlider
@export var affine_toggle:CheckButton
@export var depth_slider:HSlider
@export var lod_cascade_slider:HSlider
@export var lod_distance_slider:HSlider

var textvalue = ""
var settings_visible = false
@export var control_node:Control
@export var output_text:TextEdit
@export var copy_to_clip_button:Button
@export var generate_parameters_button:Button

func _ready() -> void:
	resolution_scale = randi_range(round(resolution_slider.min_value), round(resolution_slider.max_value))
	jitter_scale = randi_range(round(jitter_slider.min_value), round(jitter_slider.max_value))
	color_depth = randi_range(round(color_slider.min_value), round(color_slider.max_value))
	#z_depth = randf_range((depth_slider.min_value), (depth_slider.max_value))
	lod_cascades = randi_range(round(lod_cascade_slider.min_value), round(lod_cascade_slider.max_value))
	lod_distance = randf_range(lod_distance_slider.min_value, lod_distance_slider.max_value)
	
	do_affine_mapping = true if randi_range(0, 6) >= 4 else false
	_on_setting_changed()
	
	resolution_slider.value = resolution_scale
	jitter_slider.value = jitter_scale
	color_slider.value = color_depth
	lod_cascade_slider.value_changed.connect(set_lod_cascades)
	lod_distance_slider.value_changed.connect(set_lod_distance)
	#depth_slider.value = z_depth
	
	resolution_slider.value_changed.connect(set_resolution)
	color_slider.value_changed.connect(set_color_depth)
	jitter_slider.value_changed.connect(set_jitter)
	affine_toggle.toggled.connect(set_affine_mapping)
	generate_parameters_button.pressed.connect(set_parameter_string)
	copy_to_clip_button.pressed.connect(set_clip)
	#depth_slider.value_changed.connect(set_depth)
	toggle_visible()

func toggle_visible():
	settings_visible = !settings_visible
	control_node.visible = settings_visible
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if settings_visible else Input.MOUSE_MODE_CAPTURED

func set_resolution(_value):
	var scale = round(resolution_slider.value)
	resolution_scale = scale
	_on_setting_changed()

func set_jitter(_value):
	var scale = round(jitter_slider.value)
	jitter_scale = scale
	var jitter_resolution = [916/jitter_scale, 960/jitter_scale]
	_on_setting_changed()

func set_color_depth(_value):
	var depth = round(color_slider.value)
	color_depth = depth
	_on_setting_changed()

func set_depth(_value):
	var depth = round(depth_slider.value)
	z_depth = depth
	_on_setting_changed()

func set_affine_mapping(value):
	do_affine_mapping = value
	_on_setting_changed()

func set_clip():
	DisplayServer.clipboard_set(textvalue)

func set_parameter_string():
	output_text.text = textvalue

func set_lod_cascades(value):
	lod_cascades = round(value)
	_on_setting_changed()

func set_lod_distance(value):
	lod_distance = value
	_on_setting_changed()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("one"):
		set_clip()
	if Input.is_action_just_pressed("toggle_menu"):
		toggle_visible()

func _on_setting_changed():
	print("Setting changed")
	var comp = overlay_compositor as Compositor
	var res_scale = resolution_slider.max_value - resolution_scale + 1
	comp.compositor_effects[0].set_scale_factor(res_scale)
	comp.compositor_effects[0].set_color_depth(color_depth)
	var jitter_resolution = [916/jitter_scale, 960/jitter_scale]
	RenderingServer.global_shader_parameter_set("resolution", jitter_resolution)
	RenderingServer.global_shader_parameter_set("do_affine_texture_mapping", do_affine_mapping)
#	RenderingServer.global_shader_parameter_set("depth_quantization", z_depth)
	RenderingServer.global_shader_parameter_set("scale_factor", res_scale)
	RenderingServer.global_shader_parameter_set("color_depth", color_depth)
	LODCascades.set_LOD_cascades(lod_cascades)
	LODCascades.set_LOD_distance(lod_distance)
	textvalue = "rs:" + str(resolution_scale) + ",\njs:" + str(jitter_scale) + ",\ncd:" + str(color_depth) + ",\nam:" + str(do_affine_mapping) + ",\ndq" + str(z_depth)
