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
	
	# Road pz-nz
	var r0 = Vector3(1, 0, 15)
	var r1 = Vector3(-1, 0, 15)
	var r2 = Vector3(-1, 0, -15)
	var r3 = Vector3(1, 0, -15)
	var pm2 = pathmesh.instantiate()
	pm2.set_corners([r0, r1, r2, r3, r0])
	pm2.color = Color.DIM_GRAY
	pm2.position += Vector3(0, 0.01, 0) # To avoid y-fighting
	add_child(pm2)
	
	# road center->px
	var s0 = Vector3(15, 0, 1)
	var s1 = Vector3(1, 0, 1)
	var s2 = Vector3(1, 0, -1)
	var s3 = Vector3(15, 0, -1)
	var pm3 = pathmesh.instantiate()
	pm3.set_corners([s0, s1, s2, s3, s0])
	pm3.color = Color.DIM_GRAY
	pm3.position += Vector3(0, 0.01, 0)
	add_child(pm3)
