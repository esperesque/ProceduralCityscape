extends VBoxContainer

func _ready():
	set_text()
	SIGNALS.lang_changed.connect(set_text)

func set_text():
	if SETTINGS.LANG == "en":
		$HBoxContainer2/Label.text = "On using Godot"
		%bp.text = """• Lightweight
• Powerful, intuitive UI tools
• Open-source, entirely free
• Highly recommended"""
	else:
		$HBoxContainer2/Label.text = "Att använda Godot"
		%bp.text = """• Lättviktig
• Kraftfulla, intuitiva verktyg för UI
• Open-source, gratis
• Starkt rekommenderad"""
