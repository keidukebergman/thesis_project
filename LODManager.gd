extends Node
class_name LODManager
var LOD_cascades:int = 4
var LOD_distance:float = 0.8

signal set_LOD_cascade_value (value)
signal set_LOD_distance_value (value)

func set_LOD_cascades(value):
	LOD_cascades = value
	set_LOD_cascade_value.emit(value)

func set_LOD_distance(value):
	LOD_distance = value
	set_LOD_distance_value.emit(value)
