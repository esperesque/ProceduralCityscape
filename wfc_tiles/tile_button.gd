extends TextureButton

#@export var tex:Texture2D
@export var wfc_tile:Resource # Should this be a resource instead?
var hovering = false
var selected = false

func _ready():
	texture_normal = wfc_tile.tex
	update_highlight()

func _on_mouse_entered():
	hovering = true
	update_highlight()

func _on_mouse_exited():
	hovering = false
	update_highlight()

func update_highlight():
	var highlight:float
	if button_pressed:
		highlight = 0.0
	else:
		highlight = -0.3
	highlight += 0.15*int(hovering)
	material.set_shader_parameter("HIGHLIGHT", highlight)

func _on_toggled(toggled_on):
	selected = toggled_on
	hovering = false
	update_highlight()
