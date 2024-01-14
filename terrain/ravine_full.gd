extends TerrainBlock

func _ready():
	var b0 = Vector3(-3, 5, -15)
	var b1 = Vector3(-3, 5, 15)
	var b2 = Vector3(-3, -5, 15)
	var b3 = Vector3(-3, -5, -15)
	add_quadmesh(b0, b3, b2, b1, Color.DARK_GREEN)
	
	var c0 = Vector3(3, 5, -15)
	var c1 = Vector3(3, 5, 15)
	var c2 = Vector3(3, -5, 15)
	var c3 = Vector3(3, -5, -15)
	add_quadmesh(c0, c1, c2, c3, Color.DARK_GREEN)
	
