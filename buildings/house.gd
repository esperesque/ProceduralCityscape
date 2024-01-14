extends Node3D

# Vertices representing the bounding rectangle of the house
var v0:Vector3
var v1:Vector3
var v2:Vector3
var v3:Vector3

var pathmesh = preload("res://geometry/PathMesh.tscn")
var housewall = preload("res://buildings/housewall.tscn")
var roof = preload("res://buildings/roof.tscn")
var build_instantly = true
var build_step = 0

var base_color:Color = Color(0.7, 0.7, 0.5)
var dark_color:Color = Color(0.6, 0.6, 0.42)

var walls = []
var floors:int
var height

# For calculating UV coordinates... eventually
var circumference
var tile_length
var tex_tiles
var offset

var extrusions = {}
var base_mesh
var rect_path:Array[Vector3]
var mat
@export var materials:Array[Material]

# 1) Draw rect, 2 tweak corners, 3 build walls, 4 add extr., 6 remove windows, 7 add roof, 8 reset
func next_build_step():
	build_step += 1
	match build_step:
		1:
			draw_rectangle()
		2:
			tweak_corners()
		3:
			build_walls()
		4:
			add_extrusions()
		5:
			add_roof()
		6:
			reset()
		
func draw_rectangle():
	base_mesh = add_pathmesh(rect_path, Color.RED)
	base_mesh.position += Vector3(0, 0.01, 0)

func tweak_corners():
	base_mesh.queue_free()
	var i = randi_range(1, 3)
	for j in i:
		rect_path = cut_corners(rect_path)
	base_mesh = add_pathmesh(rect_path, Color.RED)
	base_mesh.position += Vector3(0, 0.01, 0)

func build_walls():
	circumference = 0.0
	for i in range(rect_path.size()-1):
		circumference += (rect_path[i+1] - rect_path[i]).length()
	
	tex_tiles = floor(circumference / 4)
	tile_length = circumference / float(tex_tiles)
	
	# build a wall and make Unity pay for it
	floors = randi_range(2, 5)
	height = floors*SETTINGS.FLOOR_HEIGHT #randf_range(5, 15)
	offset = 0.0
	for i in range(rect_path.size()-1):
		#print("adding wall")
		var wall = housewall.instantiate()
		wall.mat = mat
		wall.floors = floors
		wall.base_color = base_color
		wall.dark_color = dark_color
		wall.v0 = rect_path[i]
		wall.v1 = rect_path[i+1]
		wall.height = height
		wall.length = (rect_path[i+1] - rect_path[i]).length()
		wall.tile_length = tile_length
		wall.circumference = circumference
		wall.offset = offset
		wall.tiles = ((wall.length-offset) / circumference) * float(tex_tiles)
		offset = 1.0 - (wall.tiles - int(wall.tiles))
		add_child(wall)
		walls.append(wall)

func add_extrusions():
	if floors == 1:
		return # Don't add extrusions to 1-story buildings
	# Extrusions
	
	var wi = -1
	for w in walls:
		wi += 1
		if w.length < 7.5:
			continue # No extrusions on short walls
		var e0 = w.v1.lerp(w.v0, randf_range(0, 0.35))
		var e1 = w.v0.lerp(w.v1, randf_range(0, 0.35))
		var n = (e1-e0).cross(Vector3(0, 1, 0)).normalized()
		var e2 = e1
		var e3 = e0
		# Try to move e2, e3 outward
		var dist = 15
		var temp
		while dist > 3:
			temp = e2 + n * dist
			if test_point(temp, v0, v1, v2, v3):
				e2 = temp
				break
			else:
				dist -= 3
		if e2 == e1:
			continue # no ext
		
		
		
		dist = 15
		while dist > 3:
			temp = e3 + n * dist
			if test_point(temp, v0, v1, v2, v3):
				e3 = temp
				break
			else:
				dist -= 3
		if e3 == e0:
			continue # no ext
		
		var ext_floors = randi_range(1, floors-1)
		var ext_path:Array[Vector3] = [e0, e1, e2, e3, e0]
		var ext_height = ext_floors*SETTINGS.FLOOR_HEIGHT
		
		extrusions[wi] = {}
		extrusions[wi]["path"] = ext_path
		extrusions[wi]["floors"] = ext_floors
		extrusions[wi]["height"] = ext_height
		
		w.set_extrusion(e0, e1, ext_height + 5.0) # constant to account for roof
		
		for i in range(1, ext_path.size()-1):
			var wall = housewall.instantiate()
			wall.floors = ext_floors
			wall.base_color = base_color
			wall.dark_color = dark_color
			wall.mat = mat
			wall.v0 = ext_path[i]
			wall.v1 = ext_path[i+1]
			wall.height = ext_height
			wall.length = (ext_path[i+1] - ext_path[i]).length()
			wall.tile_length = tile_length
			wall.circumference = circumference
			wall.offset = offset
			wall.tiles = ((wall.length-offset) / circumference) * float(tex_tiles)
			offset = 1.0 - (wall.tiles - int(wall.tiles))
			add_child(wall)

func reset():
	print("resetting")
	for c in get_children():
		c.queue_free()
	build_step = 0
	
	walls = []
	extrusions = {}
	
	mat = materials.pick_random()
	
	# Find the longest side
	var side:int
	var len1 = (v1 - v0).length()
	var len2 = (v2 - v1).length()
	side = int(len1<len2) + (randi() % 2)*2
	
	# Do a rectangulus
	var bounds = [v0, v1, v2, v3]
	var u0
	var u1
	var u2
	var u3
	if side == 0 or true:
		var disp1 = randf_range(0.0, 0.35)
		var disp2 = randf_range(0.0, 0.35)
		var disp3 = randf_range(0.5, 1.0)
		u0 = v0.lerp(v1, disp1)
		u1 = v1.lerp(v0, disp2)
		var w = (v2 - v1)*disp3
		u2 = u1 + w
		u3 = u0 + w
	
	rect_path = [u0, u1, u2, u3, u0]

func add_roof():
	var r = roof.instantiate()
	r.points = rect_path
	r.position += Vector3(0,height,0)
	add_child(r)
	
	for e in extrusions:
		print(e)
		var ext_r = roof.instantiate()
		ext_r.points = extrusions[e]["path"]
		ext_r.position += Vector3(0,extrusions[e]["height"],0)
		add_child(ext_r)

func show_house():
	visible = true

func hide_house():
	visible = false

func _ready():
	if !SETTINGS.SHOWING_BUILDINGS:
		hide_house()
	
	SIGNALS.show_buildings.connect(show_house)
	SIGNALS.hide_buildings.connect(hide_house)
	if !build_instantly:
		SIGNALS.next_build_step.connect(next_build_step)
	# pick material
	mat = materials.pick_random()
	
	# Find the longest side
	var side:int
	var len1 = (v1 - v0).length()
	var len2 = (v2 - v1).length()
	side = int(len1<len2) + (randi() % 2)*2
	
	# Do a rectangulus
	var bounds = [v0, v1, v2, v3]
	var u0
	var u1
	var u2
	var u3
	if side == 0 or true:
		var disp1 = randf_range(0.0, 0.35)
		var disp2 = randf_range(0.0, 0.35)
		var disp3 = randf_range(0.5, 1.0)
		u0 = v0.lerp(v1, disp1)
		u1 = v1.lerp(v0, disp2)
		var w = (v2 - v1)*disp3
		u2 = u1 + w
		u3 = u0 + w
	
	rect_path = [u0, u1, u2, u3, u0]
	if !build_instantly:
		return # handle the rest step-by-step
	
	# blonk the corners
	var build_path = cut_corners([u0, u1, u2, u3, u0])
	while true:
		if randi_range(0, 2) < 2:
			break
		build_path = cut_corners(build_path)
	
	#var base = add_pathmesh(build_path, Color.RED)
	
	var circumference = 0.0
	for i in range(build_path.size()-1):
		circumference += (build_path[i+1] - build_path[i]).length()
	
	var tex_tiles = floor(circumference / 4) # the number of tiles to cover the
	# walls with. tiles are scaled to cover the fraction
	var tile_length = circumference / float(tex_tiles)
	#print("Circum: " + str(circumference))
	#print("Tex_tiles: " + str(tex_tiles))
	#print("Tile length: " + str(tile_length))
	
	# build a wall and make Unity pay for it
	floors = randi_range(1, SETTINGS.MAX_FLOORS)
	var height = floors*SETTINGS.FLOOR_HEIGHT #randf_range(5, 15)
	var offset = 0.0
	for i in range(build_path.size()-1):
		#print("adding wall")
		var wall = housewall.instantiate()
		wall.mat = mat
		wall.floors = floors
		wall.base_color = base_color
		wall.dark_color = dark_color
		wall.v0 = build_path[i]
		wall.v1 = build_path[i+1]
		wall.height = height
		wall.length = (build_path[i+1] - build_path[i]).length()
		wall.tile_length = tile_length
		wall.circumference = circumference
		wall.offset = offset
		wall.tiles = ((wall.length-offset) / circumference) * float(tex_tiles)
		offset = 1.0 - (wall.tiles - int(wall.tiles))
		add_child(wall)
		walls.append(wall)
	
	# roof
	var r = roof.instantiate()
	r.points = build_path
	r.position += Vector3(0,height,0)
	add_child(r)
	
	#base.position += Vector3(0, height-0.05, 0)
	
	if floors == 1:
		return # Don't add extrusions to 1-story buildings
	# Extrusions
	
	for w in walls:
		if w.length < 7.5:
			continue # No extrusions on short walls
		var e0 = w.v1.lerp(w.v0, randf_range(0, 0.35))
		var e1 = w.v0.lerp(w.v1, randf_range(0, 0.35))
		var n = (e1-e0).cross(Vector3(0, 1, 0)).normalized()
		var e2 = e1
		var e3 = e0
		# Try to move e2, e3 outward
		var dist = 15
		var temp
		while dist > 3:
			temp = e2 + n * dist
			if test_point(temp, v0, v1, v2, v3):
				e2 = temp
				break
			else:
				dist -= 3
		if e2 == e1:
			continue # no ext
		
		dist = 15
		while dist > 3:
			temp = e3 + n * dist
			if test_point(temp, v0, v1, v2, v3):
				e3 = temp
				break
			else:
				dist -= 3
		if e3 == e0:
			continue # no ext
		
		var ext_floors = randi_range(1, floors-1)
		var ext_path:Array[Vector3] = [e0, e1, e2, e3, e0]
		var ext_height = ext_floors*SETTINGS.FLOOR_HEIGHT
		
		w.set_extrusion(e0, e1, ext_height + 5.0) # constant to account for roof
		
		for i in range(1, ext_path.size()-1):
			var wall = housewall.instantiate()
			wall.floors = ext_floors
			wall.base_color = base_color
			wall.dark_color = dark_color
			wall.mat = mat
			wall.v0 = ext_path[i]
			wall.v1 = ext_path[i+1]
			wall.height = ext_height
			wall.length = (ext_path[i+1] - ext_path[i]).length()
			wall.tile_length = tile_length
			wall.circumference = circumference
			wall.offset = offset
			wall.tiles = ((wall.length-offset) / circumference) * float(tex_tiles)
			offset = 1.0 - (wall.tiles - int(wall.tiles))
			add_child(wall)
			
			var ext_r = roof.instantiate()
			ext_r.points = ext_path
			ext_r.position += Vector3(0,ext_height,0)
			add_child(ext_r)
			#walls.append(wall)
		#var ext = pathmesh.instantiate()
		#ext.set_corners([e0, e1, e2, e3, e0])
		#ext.position += Vector3(0, 0.05, 0)
		#add_child(ext)

func cut_corners(arr:Array[Vector3]) -> Array[Vector3]:
	var new_path:Array[Vector3] = []
	for i in arr.size()-1:
		if randi() % 2 == 0:
			var next = arr[i+1]
			var prev
			if i == 0:
				prev = arr[arr.size()-2]
			else:
				prev = arr[i-1]
			var c0 = arr[i].lerp(prev, 0.3)
			var c1 = arr[i].lerp(next, 0.3)
			new_path.append(c0)
			new_path.append(c1)
		else:
			new_path.append(arr[i])
	new_path.append(new_path[0])
	return new_path

func add_pathmesh(arr:Array[Vector3], clr:Color) -> MeshInstance3D:
	var pm = pathmesh.instantiate()
	pm.set_corners(arr)
	pm.color = clr
	pm.position += Vector3(0, 0.05, 0)
	add_child(pm)
	return pm

# Check if a point is within a rectangle
#https://math.stackexchange.com/questions/190111/how-to-check-if-a-point-is-inside-a-rectangle
func test_point(point:Vector3, v0:Vector3, v1:Vector3, v2:Vector3, v3:Vector3) -> bool:
	var m = Vector2(point.x, point.z)
	var a = Vector2(v0.x, v0.z)
	var b = Vector2(v1.x, v1.z)
	var c = Vector2(v2.x, v2.z)
	var d = Vector2(v3.x, v3.z)
	var p1 = (m-a).dot(b-a)
	var p2 = (b-a).dot(b-a)
	var p3 = (m-a).dot(d-a)
	var p4 = (d-a).dot(d-a)
	return (0 < p1 and p1 < p2 and 0 < p3 and p3 < p4)
