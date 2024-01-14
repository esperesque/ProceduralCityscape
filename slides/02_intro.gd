extends VBoxContainer

func _ready():
	set_text()
	SIGNALS.lang_changed.connect(set_text)

func set_text():
	if SETTINGS.LANG == "en":
		$Label.text = "Procedural cities in Godot"
		%bp.text = """• Generates random cityscapes in Godot
• Buildings generation through procedural geometry
• Terrain generation through Wave Function Collapse"""
	else:
		$Label.text = "Procedurella städer i Godot"
		%bp.text = """• Genererar slumpade stadslandskap i Godot
• Byggnader genererade via procedurell geometri
• Terräng genererad via Wave Function Collapse"""
