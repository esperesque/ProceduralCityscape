extends TerrainBlock

func _ready():
	var v0 = Vector3(15, 0, 15)
	var v1 = Vector3(-15, 0, 15)
	var v2 = Vector3(-15, 0, -15)
	var v3 = Vector3(15, 0, -15)
	
	var pm = pathmesh.instantiate()
	pm.set_corners([v0, v1, v2, v3, v0])
	pm.color = Color.DARK_GREEN
	add_child(pm)
	
	var w0 = Vector3(14, 0, 14)
	var w1 = Vector3(-14, 0, 14)
	var w2 = Vector3(-14, 0, -14)
	var w3 = Vector3(14, 0, -14)
	add_plot(w0, w1, w2, w3)
