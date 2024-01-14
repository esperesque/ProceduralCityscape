extends Node3D

var plot = preload("res://buildings/plot.tscn")

func _ready():
	var p = plot.instantiate()
	p.v0 = Vector3(5, 0, 5)
	p.v1 = Vector3(-5, 0, 5)
	p.v2 = Vector3(-5, 0, -5)
	p.v3 = Vector3(5, 0, -5)
	add_child(p)
