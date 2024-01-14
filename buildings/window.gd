extends Node3D

var v0:Vector3
var v1:Vector3
var v2:Vector3
var v3:Vector3
var quadmesh = preload("res://geometry/QuadMesh.tscn")

var light_chance = 0.3

func _ready():
	var qm = quadmesh.instantiate()
	qm.v0 = v0
	qm.v1 = v1
	qm.v2 = v2
	qm.v3 = v3
	var norm = -(v1 - v0).cross(v2 - v0).normalized()
	if randf() <= light_chance:
		$light.position = v2.lerp(v3, 0.5)
		$light.position = $light.position.lerp(v0.lerp(v1, 0.5), 0.3)
		$light.position += norm * 0.01
		qm.use_color(Color.YELLOW)
	else:
		$light.queue_free()
		qm.use_color(Color.GRAY)
	qm.position += norm * 0.01
	add_child(qm)
