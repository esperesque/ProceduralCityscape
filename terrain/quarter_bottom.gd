extends TerrainBlock

func _ready():
	var v0 = Vector3(15, -5, 15)
	var v1 = Vector3(7.5, -5, 15)
	var v2 = Vector3(7.5, -5, -15)
	var v3 = Vector3(15, -5, -15)
	add_pathmesh([v0, v1, v2, v3, v0], Color.DARK_GREEN)
	
