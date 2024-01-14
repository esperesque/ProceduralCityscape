extends TerrainBlock

func _ready():
	# Ground
	var v0 = Vector3(15, 0, 15)
	var v1 = Vector3(-15, 0, 15)
	var v2 = Vector3(-15, 0, -15)
	var v3 = Vector3(15, 0, -15)
	
	var pm = pathmesh.instantiate()
	pm.set_corners([v0, v1, v2, v3, v0])
	pm.color = Color.DARK_GREEN
	add_child(pm)
	
	# Road
	var r0 = Vector3(1, 0, 15)
	var r1 = Vector3(-1, 0, 15)
	var r2 = Vector3(-1, 0, -15)
	var r3 = Vector3(1, 0, -15)
	var pm2 = pathmesh.instantiate()
	pm2.set_corners([r0, r1, r2, r3, r0])
	pm2.color = Color.DIM_GRAY
	pm2.position += Vector3(0, 0.01, 0) # To avoid y-fighting
	add_child(pm2)

	var w0 = Vector3(14, 0, -14)
	var w1 = Vector3(14, 0, 14)
	var w2 = Vector3(2, 0, 14)
	var w3 = Vector3(2, 0, -14)
	add_plot(w0, w1, w2, w3)

	var u0 = Vector3(-2, 0, -14)
	var u1 = Vector3(-2, 0, 14)
	var u2 = Vector3(-14, 0, 14)
	var u3 = Vector3(-14, 0, -14)
	add_plot(u0, u1, u2, u3)
