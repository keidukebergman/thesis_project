extends CSGBox3D

func _ready() -> void:
	process_csg_to_centroid_mesh()

func process_csg_to_centroid_mesh():
	# 1. Force the CSG to generate its mesh and grab it
	var mesh_data = get_meshes()
	if mesh_data.is_empty():
		return
	
	# get_meshes() returns [Transform, Mesh]. We want the Mesh.
	var raw_mesh = mesh_data[1] 
	
	# 2. Convert to ArrayMesh and ensure "flat" vertices (no shared vertices)
	# This is crucial so each triangle has its own unique color.
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(raw_mesh, 0)
	surface_tool.deindex() # This "unwelds" the mesh
	var flat_mesh = surface_tool.commit()

	# 3. Use MeshDataTool to bake the centers
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(flat_mesh, 0)

	for face_idx in mdt.get_face_count():
		var v0 = mdt.get_vertex(mdt.get_face_vertex(face_idx, 0))
		var v1 = mdt.get_vertex(mdt.get_face_vertex(face_idx, 1))
		var v2 = mdt.get_vertex(mdt.get_face_vertex(face_idx, 2))
		
		var centroid = (v0 + v1 + v2) / 3.0
		var center_color = Color(centroid.x, centroid.y, centroid.z)
		
		for i in range(3):
			mdt.set_vertex_color(mdt.get_face_vertex(face_idx, i), center_color)

	# 4. Commit to a new MeshInstance3D or replace the CSG display
	# Since CSG objects regenerate, it's often better to spawn a MeshInstance
	var final_mesh = mdt.commit_to_surface(ArrayMesh.new())
	
	# Create/Update a MeshInstance child to show the result
	var display = get_node_or_null("CentroidResult")
	if not display:
		display = MeshInstance3D.new()
		display.name = "CentroidResult"
		add_child(display)
		display.owner = get_tree().edited_scene_root
	
	display.mesh = final_mesh
	# Hide the CSG box so we only see the result
	self.visible = false 
	print("Centroid baking complete on child node 'CentroidResult'!")
