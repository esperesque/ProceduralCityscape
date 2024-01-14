extends VBoxContainer

func _ready():
	set_text()
	SIGNALS.lang_changed.connect(set_text)

func set_text():
	if SETTINGS.LANG == "en":
		$Label.text = "Implementation"
		%bp.text = """• Godot provides classes for primitives such as boxes, planes, quads...
• ...these were not used! Everything is triangle tables
• No models or textures in the project - it's all vector math
• All lighting is handled by Godot"""
	else:
		$Label.text = "Implementering"
		%bp.text = """• Godot förser klasser för primitiver som lådor, plan, quads...
• ...dessa har inte använts! Allting är triangeltabeller
• Inga modeller eller texturer i projektet - bara vektormatte
• All ljussättning hanterad av Godot"""
