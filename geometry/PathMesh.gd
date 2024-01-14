extends MeshInstance3D

# Constructs a polygon from a list of vertices representing a closed path
# The polygon is triangulated using the centroid, so this will not work for shapes
# where the centroid is outside the bounded area, such as narrow L-shapes

# Additionally, the normals are calculated as if every vertex is in a shared plane.
# Results may be unpredictable if this is not the case.

var corners = []
var color = Color.AQUAMARINE
var centroid:Vector3

# Corners defined CLOCKWISE for some reason
func set_corners(c):
	corners = c

func _ready():
	if corners.size() == 0:
		print("Corners not set! Deleting PathMesh")
		queue_free()
		return
	
	#region Centroid calculation
	var area = 0.0
	for i in range(0, corners.size() - 1):
		area += 0.5*(corners[i].x*corners[i+1].z - corners[i+1].x*corners[i].z)
	
	var cx = 0.0
	var cy = 0.0
	var cz = 0.0
	
	# Hacky solution that I think should work for 1) quads and 2) irregular shapes with constant y
	var total_y = 0.0
	for i in range(0, corners.size() - 1):
		total_y += corners[i].y
	cy = total_y / (corners.size() - 1)
	
	for i in range(0, corners.size() - 1):
		cx += (1/(6*area)) * (corners[i].x+corners[i+1].x)*(corners[i].x*corners[i+1].z - corners[i+1].x*corners[i].z)
		cz += (1/(6*area)) * (corners[i].z+corners[i+1].z)*(corners[i].x*corners[i+1].z - corners[i+1].x*corners[i].z)
	
	centroid = Vector3(cx, cy, cz)
	#endregion
	
	# Draw the triangles
	mesh = ArrayMesh.new()
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	for i in range(corners.size() -1):
		verts.append_array([corners[i], corners[i+1], centroid])
		var u = centroid - corners[i]
		var v = centroid - corners[i+1]
		var norm = v.cross(u)
		norm = norm.normalized()
		#print(norm)
		normals.append_array([norm, norm, norm])
	for i in range(verts.size()):
		indices.append(i)
	for i in indices.size():
		#TODO: Make not bad
		uvs.append(Vector2(1, 1))
	
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.surface_set_material(0, mat)
