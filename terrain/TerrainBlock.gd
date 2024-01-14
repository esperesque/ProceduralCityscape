class_name TerrainBlock extends Node3D

@export var px_socket:String
@export var nx_socket:String
@export var py_socket:String
@export var ny_socket:String
@export var pz_socket:String
@export var nz_socket:String

var pathmesh = preload("res://geometry/PathMesh.tscn")
var quadmesh = preload("res://geometry/QuadMesh.tscn")
var plot = preload("res://buildings/plot.tscn")
var rot_ind:int

# Lists of all the block IDs to which this connects
var px_connections = []
var nx_connections = []
var py_connections = []
var ny_connections = []
var pz_connections = []
var nz_connections = []

# Rotate sockets clockwise around the y axis
func rotate_sockets(times:int):
	rot_ind = times
	for i in times:
		var old_px = px_socket
		px_socket = nz_socket
		nz_socket = nx_socket
		nx_socket = pz_socket
		pz_socket = old_px

func add_pathmesh(arr:Array[Vector3], clr:Color):
	var pm = pathmesh.instantiate()
	pm.set_corners(arr)
	pm.color = clr
	add_child(pm)

func add_plot(v0:Vector3, v1:Vector3, v2:Vector3, v3:Vector3):
	var pl = plot.instantiate()
	pl.v0 = v0
	pl.v1 = v1
	pl.v2 = v2
	pl.v3 = v3
	add_child(pl)

func add_quadmesh(v0:Vector3, v1:Vector3, v2:Vector3, v3:Vector3, clr:Color):
	var qm = quadmesh.instantiate()
	qm.v0 = v0
	qm.v1 = v1
	qm.v2 = v2
	qm.v3 = v3
	qm.use_color(clr)
	add_child(qm)
