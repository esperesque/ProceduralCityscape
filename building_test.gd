extends Node3D

var plot = preload("res://buildings/plot.tscn")

func hide_test():
	visible = false

func show_test():
	visible = true

func _ready():
	SIGNALS.hide_build_test.connect(hide_test)
	SIGNALS.show_build_test.connect(show_test)
	var p = plot.instantiate()
	p.v0 = Vector3(15, 0, 15)
	p.v1 = Vector3(-15, 0, 15)
	p.v2 = Vector3(-15, 0, -15)
	p.v3 = Vector3(15, 0, -15)
	p.build_instantly = false
	add_child(p)
	
