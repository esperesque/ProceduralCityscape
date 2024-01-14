extends Node3D

var v0:Vector3
var v1:Vector3
var height:float
var length:float	# length of wall segment
var circumference:float # circumference of house
var tiles:float
var tile_length:float
var offset:float
var floors:int
var base_color:Color
var dark_color:Color
var mat:Material = load("res://material/house_blue.tres")

var window_width = 0.2
var windows = []

var pathmesh = preload("res://geometry/PathMesh.tscn")
var quadmesh = preload("res://geometry/QuadMesh.tscn")
var window = preload("res://buildings/window.tscn")

func _ready():
	var v2 = v1 + Vector3(0.0, height, 0)
	var v3 = v0 + Vector3(0.0, height, 0)
	var quad = quadmesh.instantiate()
	quad.v0 = v0
	quad.v1 = v1
	quad.v2 = v2
	quad.v3 = v3
	#quad.uv_x_offset = randf_range(0, 0.8)
	quad.uv_x = tiles
	quad.uv_x_offset = offset
	quad.uv_y = height/tile_length
	quad.use_material(mat)
	add_child(quad)

	var window_count = floor(length / 3.0)
	var segments = (window_count * 3) + 2
	var segment_length = length/segments
	var side_vec = (v1 - v0).normalized() # vector from right -> left on the wall
	var up_vec = (v3 - v0).normalized()
	for f in floors:
		var f0 = v0 + up_vec*SETTINGS.FLOOR_HEIGHT*f
		for i in window_count:
			var seg = (i*3)+2
			var w0 = f0 + segment_length*seg*side_vec + up_vec*SETTINGS.WINDOW_BOT*SETTINGS.FLOOR_HEIGHT
			var w1 = w0 + segment_length*side_vec
			var w2 = f0 + segment_length*(seg+1)*side_vec + up_vec*SETTINGS.WINDOW_TOP*SETTINGS.FLOOR_HEIGHT
			var w3 = w2 - segment_length*side_vec
			var w = window.instantiate()
			w.v0 = w0
			w.v1 = w1
			w.v2 = w2
			w.v3 = w3
			add_child(w)
			windows.append(w)

# Remove all windows covered by the extrusion
func set_extrusion(e0, e1, ext_height):
	for w in windows:
		if w.v0.y < ext_height:
			w.queue_free()
