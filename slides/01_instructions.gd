extends CenterContainer

func _ready():
	set_text()
	SIGNALS.lang_changed.connect(set_text)

func set_text():
	if SETTINGS.LANG == "en":
		$Label.text = """Use the left and right arrow keys to change slides.
Press TAB to switch between the slideshow and 3D scene.
The camera is controlled with WASD and the mouse."""
	else:
		$Label.text = """Vänster och höger piltangent byter slide.
TAB växlar mellan presentation och 3D-scenen.
Kameran styrs med WASD och mus."""
