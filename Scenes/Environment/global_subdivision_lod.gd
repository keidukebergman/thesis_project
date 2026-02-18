extends Node3D

@export var LOD_0 : Array[MeshInstance3D]
@export var LOD_1 : Array[MeshInstance3D]
@export var LOD_2 : Array[MeshInstance3D]
@export var LOD_3 : Array[MeshInstance3D]

var distance = 1.0
var cascades = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LODCascades.set_LOD_cascade_value.connect(set_LOD_cascades)
	LODCascades.set_LOD_distance_value.connect(set_LOD_distance)
	print("LOD active")

func set_LOD_cascades(value):
	cascades = value
	update_LOD_settings()
	

func set_LOD_distance(value):
	distance = value
	update_LOD_settings()

func update_LOD_settings():
	update_LOD_inner_loop(LOD_0, 0, cascades)
	update_LOD_inner_loop(LOD_1, 1, cascades)
	update_LOD_inner_loop(LOD_2, 2, cascades)
	update_LOD_inner_loop(LOD_3, 3, cascades)

func update_LOD_inner_loop (lods:Array[MeshInstance3D], level:int, target_level:int):
	var index = target_level - (level+1)
	var start_distance = index * distance
	var end_distance = index * distance + distance
	if index == target_level-1:
		end_distance = 99999999
	if index -1 < 0:
		start_distance = 0
	for lod in lods:
		lod.visible = index >= 0
		lod.visibility_range_begin = start_distance
		lod.visibility_range_end = end_distance
