extends MeshInstance3D

var v0:Vector3
var v1:Vector3
var v2:Vector3
var v3:Vector3
var color:Color = Color.ROSY_BROWN
var use_texture = false
var uv_x = 1.0
var uv_y = 1.0
var uv_x_offset = 0.0
var uv_y_offset = 0.0
var mat:Material

var grad_mat = preload("res://material/gradient.tres")

@export var materials:Array[Material]

func show_gradient():
	mesh.surface_set_material(0, grad_mat)
	
func hide_gradient():
	mesh.surface_set_material(0, mat)

func _ready():
	if use_texture:
		SIGNALS.show_gradient.connect(show_gradient)
		SIGNALS.hide_gradient.connect(hide_gradient)
	# Draw the triangles
	mesh = ArrayMesh.new()
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	verts.append_array([v0, v1, v2, v0, v2, v3])
	
	var u0 = Vector2(uv_x + uv_x_offset, uv_y)
	var u1 = Vector2(0 + uv_x_offset, uv_y)
	var u2 = Vector2(uv_x + uv_x_offset, 0)
	var u3 = Vector2(0 + uv_x_offset, 0)
	uvs.append_array([u0, u1, u3, u0, u3, u2])
	
	var vec1 = v3 - v0
	var vec2 = v1 - v0
	var norm = vec1.cross(vec2)
	norm = norm.normalized()
	normals.append_array([norm, norm, norm, norm, norm, norm])
	indices.append_array([0, 1, 2, 3, 4, 5])
	
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	
	if use_texture:
		pass
		##mat.albedo_texture = load("res://gradient.png")
		#mat.albedo_texture = load("res://brick.jpg")
		#mat = load("res://material/house_ext.tres")
	else:
		mat = StandardMaterial3D.new()
		mat.albedo_color = color
		
	mesh.surface_set_material(0, mat)

func use_color(clr:Color):
	color = clr
	use_texture = false

func use_material(m:Material):
	mat = m
	use_texture = true

#func set_surface(use_tex:bool, clr:Color=Color.WHITE):
	## t = 1: texture, t = 0: use clr
	##mat = load("res://material/house_ext.tres")
	#use_texture = use_tex
	#color = clr
