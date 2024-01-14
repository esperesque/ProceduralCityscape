extends VBoxContainer

@export var all_tiles:Array[TerrainTile]

var cell_scn = preload("res://wfc_tiles/cell.tscn")
var tilebutton = preload("res://wfc_tiles/tile_button.tscn")
var map_x = 8
var map_y = 8
var cell_scale = 2.0
var step = 0

var selected_tiles = []
var cell_matrix = {}

var lowest_entropy = 999
var next_coords:Vector2

# Stores the position of the last few tiles placed, for backtracking
var last_tiles:Array[Vector2] = []
var max_backtracks = 5

func _ready():
	
	$"%tilemap".columns = map_x
	for y in map_y: # Switched y and x around to account for the order in which the grid is filled in
		for x in map_x:
			cell_matrix[Vector2(x, y)] = {} # nested dictionary
			var new_cell = cell_scn.instantiate()
			new_cell.sc = cell_scale
			$"%tilemap".add_child(new_cell)
			cell_matrix[Vector2(x, y)]["cell"] = new_cell
			cell_matrix[Vector2(x, y)]["tile"] = null
	var count = -1
	for t1 in all_tiles:
		count += 1
		var tbutton = tilebutton.instantiate()
		tbutton.wfc_tile = t1
		if count <= 10:
			tbutton.button_pressed = true
			tbutton.selected = true
		else:
			tbutton.button_pressed = false
			tbutton.selected = false
		$"%select_grid".add_child(tbutton)
		for t2 in all_tiles:
			if t1.px_socket == t2.nx_socket:
				t1.px_connections.append(t2)
			if t1.nx_socket == t2.px_socket:
				t1.nx_connections.append(t2)
			if t1.py_socket == t2.ny_socket:
				t1.py_connections.append(t2)
			if t1.ny_socket == t2.py_socket:
				t1.ny_connections.append(t2)

func set_selected_tiles():
	selected_tiles = []
	for t in $"%select_grid".get_children():
		if t.selected: # No idea why "pressed" doesn't work here
			selected_tiles.append(t.wfc_tile)

func _on_generate_pressed():
	#reset()
	$gen_timer.start()

func reset():
	for x in map_x:
		for y in map_y:
			var vec = Vector2(x, y)
			cell_matrix[vec]["tile"] = null
			cell_matrix[vec]["cell"].reset()
	
	step = 0

func _on_step_pressed():
	if step == 9999:
		reset()
		return
	if step == 0:
		set_selected_tiles()
		for x in map_x:
			for y in map_y:
				cell_matrix[Vector2(x, y)]["possible"] = selected_tiles
		next_coords = update_entropy()
		if next_coords == Vector2(-1, -1):
			backtrack()
			return
		next_coords = Vector2(randi_range(0, map_x-1), randi_range(0, map_y-1))
		#return
	
	var t = cell_matrix[next_coords]["possible"].pick_random()
	set_tile(next_coords, t)
	next_coords = update_entropy()
	if next_coords == Vector2(-1, -1):
		backtrack()
		return
	elif next_coords == Vector2(999, 999):
		$gen_timer.stop()
		step = 9999
	else:
		step += 1

func wfc_generation():
	if selected_tiles.size() == 0:
		return
	
	for x in map_x:
		for y in map_y:
			cell_matrix[Vector2(x, y)]["possible"] = selected_tiles
	var first_cell = Vector2(randi_range(0, map_x-1), randi_range(0, map_y-1))
	set_tile(first_cell, selected_tiles.pick_random())
	update_entropy()
	
	var tiles_to_fill = (map_x * map_y) - 1
	
	while true:
		lowest_entropy = 999
		var last_low_entropy_coords = null
		for x in map_x:
			for y in map_y:
				if cell_matrix[Vector2(x, y)]["cell"].entropy < lowest_entropy and cell_matrix[Vector2(x, y)]["cell"].entropy > 0:
					lowest_entropy = cell_matrix[Vector2(x, y)]["cell"].entropy
					last_low_entropy_coords = Vector2(x, y)
		
		if last_low_entropy_coords == null:
			break
		
		var t = cell_matrix[last_low_entropy_coords]["possible"].pick_random()
		set_tile(last_low_entropy_coords, t)
		
		if lowest_entropy == 999:
			break
		else:
			update_entropy()
		#tiles_to_fill -= 5

# Updates the entropy and returns the position with the lowest value
# Returns Vector2(-1, -1) if an entropy value of 0 is created
func update_entropy() -> Vector2:
	var found_zero = false
	var lowest = 999
	var coords = Vector2(999, 999)
	for x in map_x:
		for y in map_y:
			var vec = Vector2(x, y)
			if cell_matrix[vec]["tile"] != null:
				continue
			
			var possibles = selected_tiles
			if x > 0:
				var left = cell_matrix[Vector2(x-1, y)]["tile"]
				if left != null:
					possibles = intersect(possibles, left.px_connections)
			if x < map_x-1:
				var right = cell_matrix[Vector2(x+1, y)]["tile"]
				if right != null:
					possibles = intersect(possibles, right.nx_connections)
			if y > 0:
				var up = cell_matrix[Vector2(x, y-1)]["tile"]
				if up != null:
					possibles = intersect(possibles, up.py_connections)
			if y < map_y-1:
				var down = cell_matrix[Vector2(x, y+1)]["tile"]
				if down != null:
					possibles = intersect(possibles, down.ny_connections)
			var ent = possibles.size()
			if ent == 0:
				print("Found zero")
				found_zero = true
			cell_matrix[vec]["possible"] = possibles
			cell_matrix[vec]["cell"].set_entropy(ent)
			if ent < lowest and ent > 0:
				lowest = ent
				coords = vec
	if found_zero:
		return Vector2(-1, -1)
	else:
		return coords

func backtrack():
	next_coords = last_tiles[0]
	for v in last_tiles:
		clear_tile(v)
	last_tiles = []

func clear_tile(vec):
	cell_matrix[vec]["tile"] = null
	cell_matrix[vec]["cell"].reset()

func set_tile(vec, t):
	if last_tiles.size() >= max_backtracks:
		last_tiles.pop_front()
	last_tiles.append(vec)
	#print(last_tiles)
	cell_matrix[vec]["tile"] = t
	cell_matrix[vec]["cell"].set_tile(t)

# Test function, delete later
func full_random():
	if selected_tiles.size() == 0:
		return
	for x in map_x:
		for y in map_y:
			var t = selected_tiles.pick_random()
			cell_matrix[Vector2(x, y)]["cell"].set_tile(t)

func intersect(arr1:Array, arr2:Array):
	var new_array = []
	for e in arr1:
		if arr2.has(e):
			new_array.append(e)
	return new_array


func _on_gen_timer_timeout():
	_on_step_pressed()
