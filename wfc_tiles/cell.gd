extends Control

var entropy:int = -1
var sc = 0.2

func _ready():
	size = Vector2(32, 32) * sc
	custom_minimum_size = size
	$TextureRect.scale = Vector2(sc, sc)
	$entropy.label_settings.font_size = 12 * sc

func set_tile(t:TerrainTile):
	$TextureRect.texture = t.tex
	$entropy.visible = false
	entropy = -1

func set_entropy(n:int):
	$entropy.text = str(n)
	$entropy.visible = true
	entropy = n

func reset():
	$TextureRect.texture = load("res://wfc_tiles/empty_cell.png")
	entropy = -1
