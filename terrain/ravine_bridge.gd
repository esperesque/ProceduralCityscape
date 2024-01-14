extends TerrainBlock

func _ready():
	var v0 = Vector3(15, 0, 15)
	var v1 = Vector3(3, 0, 15)
	var v2 = Vector3(3, 0, -15)
	var v3 = Vector3(15, 0, -15)
	
	var pm = pathmesh.instantiate()
	pm.set_corners([v0, v1, v2, v3, v0])
	pm.color = Color.DARK_GREEN
	add_child(pm)
	
	var a0 = Vector3(-3, 0, 15)
	var a1 = Vector3(-15, 0, 15)
	var a2 = Vector3(-15, 0, -15)
	var a3 = Vector3(-3, 0, -15)
	add_pathmesh([a0, a1, a2, a3, a0], Color.DARK_GREEN)
	
	var b0 = Vector3(-3, 0, -15)
	var b1 = Vector3(-3, 0, 15)
	var b2 = Vector3(-3, -5, 15)
	var b3 = Vector3(-3, -5, -15)
	add_quadmesh(b0, b3, b2, b1, Color.DARK_GREEN)
	
	var c0 = Vector3(3, 0, -15)
	var c1 = Vector3(3, 0, 15)
	var c2 = Vector3(3, -5, 15)
	var c3 = Vector3(3, -5, -15)
	add_quadmesh(c0, c1, c2, c3, Color.DARK_GREEN)
	
	var d0 = Vector3(-3, 0.01, -1)
	var d1 = Vector3(-3, 0.01, 1)
	var d2 = Vector3(-15, 0.01, 1)
	var d3 = Vector3(-15, 0.01, -1)
	add_quadmesh(d0, d1, d2, d3, Color.DIM_GRAY)
	
	var e0 = Vector3(15, 0.01, -1)
	var e1 = Vector3(15, 0.01, 1)
	var e2 = Vector3(3, 0.01, 1)
	var e3 = Vector3(3, 0.01, -1)
	add_quadmesh(e0, e1, e2, e3, Color.DIM_GRAY)
	
	var f0 = Vector3(3, 0.00, -1.5)
	var f1 = Vector3(3, 0.00, 1.5)
	var f2 = Vector3(-3, 0.00, 1.5)
	var f3 = Vector3(-3, 0.0, -1.5)
	add_quadmesh(f0, f1, f2, f3, Color.LIGHT_SLATE_GRAY)
	
	#var w0 = Vector3(14, 0, 14)
	#var w1 = Vector3(-14, 0, 14)
	#var w2 = Vector3(-14, 0, -14)
	#var w3 = Vector3(14, 0, -14)
	#add_plot(w0, w1, w2, w3)
