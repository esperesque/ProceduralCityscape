extends Node3D

@export var terrain_blocks:Array[PackedScene]
var all_blocks:Array[TerrainBlock] = []

var map_x = 4
var map_y = 3
var map_z = 4

var cell_matrix = {}
var cleared = true

var floor_height = 4.0

var last_blocks:Array[Vector3] = []
var max_backtracks = 5

func show_ui():
	$CanvasLayer.visible = true
	
func hide_ui():
	$CanvasLayer.visible = false

func _ready():
	var cam_pos = Vector3(0, 0, 0)
	cam_pos.x = (float(map_x)/2.0) * 30
	cam_pos.y = (map_y * 10) + 5
	cam_pos.z = (float(map_z)/2.0) * 30
	$free_camera.position = cam_pos
	
	# Populate all_blocks
	for b in terrain_blocks:
		for i in 4:
			var variant = b.instantiate()
			variant.name = variant.name + str(i)
			variant.rotation.y = deg_to_rad(-90*i)
			variant.rotate_sockets(i)
			all_blocks.append(variant)
	
	for b in all_blocks:
		for i in all_blocks.size():
			# Check px-connection
			if sockets_connect(b.px_socket, all_blocks[i].nx_socket):
				b.px_connections.append(i)
				#b.px_connections.append(all_blocks[i])
			# Check nx-connection
			if sockets_connect(b.nx_socket, all_blocks[i].px_socket):
				b.nx_connections.append(i)
				#b.nx_connections.append(all_blocks[i])
			# Check py-connection
			if sockets_connect(b.py_socket, all_blocks[i].ny_socket, b.rot_ind, all_blocks[i].rot_ind):
				b.py_connections.append(i)
			# Check ny-connection
			if sockets_connect(b.ny_socket, all_blocks[i].py_socket, b.rot_ind, all_blocks[i].rot_ind):
				b.ny_connections.append(i)
			# Check pz-connection
			if sockets_connect(b.pz_socket, all_blocks[i].nz_socket):
				b.pz_connections.append(i)
			# Check nz-connection
			if sockets_connect(b.nz_socket, all_blocks[i].pz_socket):
				b.nz_connections.append(i)
	#setup_matrix()
	
func setup_matrix():
	# Setup cell matrix
	for x in map_x:
		for y in map_y:
			for z in map_z:
				var vec = Vector3(x, y, z)
				cell_matrix[vec] = {}
				cell_matrix[vec]["possible"] = range(all_blocks.size())
				cell_matrix[vec]["block"] = null
				cell_matrix[vec]["loaded_obj"] = null
				#set_block(vec, all_blocks.pick_random())

func generate():
	setup_matrix()
	var first_cell = Vector3(randi_range(0,map_x-1), randi_range(0,map_y-1), randi_range(0,map_z-1))
	#set_block(first_cell, all_blocks.pick_random())
	set_block(first_cell, all_blocks[0])
	
	while true:
		var next = update_entropy()
		if next == Vector3(-1, -1, -1):
			next = last_blocks[0]
			backtrack()
		elif next == Vector3(999, 999, 999):
			break
		var block_id = cell_matrix[next]["possible"].pick_random()
		var block = all_blocks[block_id]
		set_block(next, block)
	cleared = false

func clear():
	for x in map_x:
		for y in map_y:
			for z in map_z:
				var vec = Vector3(x, y, z)
				cell_matrix[vec]["possible"] = range(all_blocks.size())
				cell_matrix[vec]["block"] = null
				if cell_matrix[vec]["loaded_obj"] != null:
					cell_matrix[vec]["loaded_obj"].queue_free()
	cleared = true

func update_entropy() -> Vector3:
	var found_zero = false
	var lowest_entropy = 9999
	var next = Vector3(999, 999, 999)
	for x in map_x:
		for y in map_y:
			for z in map_z:
				var vec = Vector3(x, y, z)
				if cell_matrix[vec]["block"] != null:
					continue
				
				var possibles = range(all_blocks.size())
				#var possibles = all_blocks
				if x > 0:
					var left = cell_matrix[Vector3(x-1, y, z)]["block"]
					if left != null:
						#print("left: Comparing " + str(possibles) + " with " + str(left.px_connections))
						possibles = intersect(possibles, left.px_connections)
				if x < map_x - 1:
					var right = cell_matrix[Vector3(x+1, y, z)]["block"]
					if right != null:
						#print("right: Comparing " + str(possibles) + " with " + str(right.nx_connections))
						possibles = intersect(possibles, right.nx_connections)
				if y > 0:
					var left = cell_matrix[Vector3(x, y-1, z)]["block"]
					if left != null:
						possibles = intersect(possibles, left.py_connections)
				if y < map_y - 1:
					var right = cell_matrix[Vector3(x, y+1, z)]["block"]
					if right != null:
						possibles = intersect(possibles, right.ny_connections)
				if z > 0:
					var left = cell_matrix[Vector3(x, y, z-1)]["block"]
					if left != null:
						possibles = intersect(possibles, left.pz_connections)
				if z < map_z - 1:
					var right = cell_matrix[Vector3(x, y, z+1)]["block"]
					if right != null:
						possibles = intersect(possibles, right.nz_connections)
				#print("Possibles after: " + str(possibles.size()))
				cell_matrix[vec]["possible"] = possibles
				var entropy = possibles.size()
				if entropy == 0:
					found_zero = true
				if entropy < lowest_entropy and entropy > 0:
					lowest_entropy = entropy
					next = vec
	if found_zero:
		return Vector3(-1, -1, -1)
	else:
		return next

func set_block(vec, block):
	if last_blocks.size() >= max_backtracks:
		last_blocks.pop_front()
	last_blocks.append(vec)
	var nb = block.duplicate()
	#var nb = all_blocks[block].duplicate()
	nb.position = Vector3(vec.x*30, vec.y*10, vec.z*30)
	cell_matrix[vec]["block"] = block
	cell_matrix[vec]["loaded_obj"] = nb
	$terrain.add_child(nb)

func backtrack():
	#next_coords = last_blocks[0]
	for v in last_blocks:
		clear_block(v)
	last_blocks = []

func clear_block(vec):
	cell_matrix[vec]["possible"] = range(all_blocks.size())
	cell_matrix[vec]["block"] = null
	if cell_matrix[vec]["loaded_obj"] != null:
		cell_matrix[vec]["loaded_obj"].queue_free()

func intersect(arr1:Array, arr2:Array):
	var new_array = []
	for e in arr1:
		if arr2.has(e):
			new_array.append(e)
	return new_array

# Sockets have the format foo|bar,etc, where the first word is what neighbour
# parts check if they can connect to, and the subsequent words are sockets this
# part can connect to.
# foo|bar|cy means "check y", for sockets that are not rotation-agnostic when connecting
# in the y-axis
func sockets_connect(a:String, b:String, a_rot:int=0, b_rot:int=0) -> bool:
	var a_id = a.split("|")[0]
	var a_connects = a.split("|")[1].split(",")
	var b_id = b.split("|")[0]
	var b_connects = b.split("|")[1].split(",")
	
	if a.split("|").size() == 3:
		if a.split("|")[2] == "cy":
			return b_connects.has(a_id) and a_connects.has(b_id) and a_rot == b_rot
	
	return b_connects.has(a_id) and a_connects.has(b_id)

func _on_generate_pressed():
	if !cleared:
		clear()
	generate()

func _on_clear_pressed():
	clear()

func _on_spin_x_value_changed(value):
	map_x = value

func _on_spin_y_value_changed(value):
	map_y = value

func _on_spin_z_value_changed(value):
	map_z = value

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


func _on_check_plots_toggled(toggled_on):
	if toggled_on:
		SIGNALS.show_plots.emit()
		SETTINGS.SHOWING_PLOTS = true
	else:
		SIGNALS.hide_plots.emit()
		SETTINGS.SHOWING_PLOTS = false

func _on_check_buildings_toggled(toggled_on):
	if toggled_on:
		SIGNALS.show_buildings.emit()
		SETTINGS.SHOWING_BUILDINGS = true
	else:
		SIGNALS.hide_buildings.emit()
		SETTINGS.SHOWING_BUILDINGS = false


func _on_check_gradient_toggled(toggled_on):
	if toggled_on:
		SIGNALS.show_gradient.emit()
	else:
		SIGNALS.hide_gradient.emit()
