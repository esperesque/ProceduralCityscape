extends Node3D

var points:Array[Vector3] = []
var quadmesh = preload("res://geometry/QuadMesh.tscn")
var pathmesh = preload("res://geometry/PathMesh.tscn")

var height = 3.0
var overhang = 2.0 # distance beyond the walls that the roof overhangs
var inner_lerp = 2.0 # how much to move the inner points toward the centroid
var color = Color.BROWN

func _ready():
	if points.size() == 0:
		print("Roof instanced without points set! Deleting")
		queue_free()
		return
	
	# calculate centroid of points
	var area = 0.0
	for i in range(0, points.size() - 1):
		area += 0.5*(points[i].x*points[i+1].z - points[i+1].x*points[i].z)
	
	var cx = 0.0
	var cy = 0.0
	var cz = 0.0
	
	for i in range(0, points.size() - 1):
		cx += (1/(6*area)) * (points[i].x+points[i+1].x)*(points[i].x*points[i+1].z - points[i+1].x*points[i].z)
		cz += (1/(6*area)) * (points[i].z+points[i+1].z)*(points[i].x*points[i+1].z - points[i+1].x*points[i].z)
	
	var centroid = Vector3(cx, cy, cz)
	
	var outer_points = []
	var inner_points = []
	for p in points:
		# set outer
		var vec_from_c = p - centroid
		vec_from_c = vec_from_c.normalized()
		var outer = p + vec_from_c*overhang
		outer_points.append(outer)
		
		# set inner
		var inner = p.lerp(centroid, 0.1) + Vector3(0, height, 0)
		#var inner = p - vec_from_c*inner_lerp + Vector3(0,height,0)
		inner_points.append(inner)
	
	for i in range(points.size() - 1):
		var q = quadmesh.instantiate()
		q.v0 = outer_points[i]
		q.v3 = inner_points[i]
		q.v2 = inner_points[i+1]
		q.v1 = outer_points[i+1]
		q.use_color(color)
		add_child(q)
	
	var pm = pathmesh.instantiate()
	var subroof = outer_points
	subroof.reverse()
	pm.set_corners(subroof)
	pm.color = color
	add_child(pm)
	
	var top = pathmesh.instantiate()
	top.color = color
	top.set_corners(inner_points)
	add_child(top)
