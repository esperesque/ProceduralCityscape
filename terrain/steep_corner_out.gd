extends TerrainBlock

func _ready():
	var v0 = Vector3(7.5, 5, 7.5)
	var v1 = Vector3(15, 5, 7.5)
	var v2 = Vector3(15, -5, -7.5)
	var v3 = Vector3(7.5, -5, -7.5)
	add_pathmesh([v0, v3, v2, v1, v0], Color.PINK)
	
	var w0 = Vector3(7.5, 5, 15)
	var w1 = Vector3(7.5, 5, 7.5)
	var w2 = Vector3(-7.5, -5, 7.5)
	var w3 = Vector3(-7.5, -5, 15)
	add_pathmesh([w0, w3, w2, w1, w0], Color.PINK)
