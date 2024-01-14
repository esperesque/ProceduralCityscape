extends Node3D

var v0:Vector3
var v1:Vector3
var v2:Vector3
var v3:Vector3

var base_colors = [Color(0.7, 0.7, 0.5), Color(1.0, 0.5, 0.5), Color(0.5, 1.0, 0.5)]
var dark_colors = [Color(0.6, 0.6, 0.42), Color(0.8, 0.4, 0.4), Color(0.4,0.8,0.4)]

var build_instantly = true
var pathmesh = preload("res://geometry/PathMesh.tscn")
var pm = null
var house = preload("res://buildings/house.tscn")

func show_plot():
	if pm != null:
		pm.visible = true

func hide_plot():
	if pm != null:
		pm.visible = false

func _ready():
	if randf() > SETTINGS.DENSITY:
		queue_free()
	SIGNALS.show_plots.connect(show_plot)
	SIGNALS.hide_plots.connect(hide_plot)
	show_pathmesh()
	place_house()
	if !SETTINGS.SHOWING_PLOTS:
		hide_plot()

func show_pathmesh():
	pm = pathmesh.instantiate()
	pm.set_corners([v0, v1, v2, v3, v0])
	pm.color = Color.AZURE
	pm.position += Vector3(0, 0.01, 0)
	add_child(pm)

func place_house():
	var h = house.instantiate()
	var color_id = randi_range(0, base_colors.size()-1)
	h.base_color = base_colors[color_id]
	h.dark_color = dark_colors[color_id]
	h.build_instantly = build_instantly
	h.v0 = v0
	h.v1 = v1
	h.v2 = v2
	h.v3 = v3
	add_child(h)
