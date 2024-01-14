extends VBoxContainer

func _ready():
	set_text()
	SIGNALS.lang_changed.connect(set_text)

func set_text():
	if SETTINGS.LANG == "en":
		$Label.text = "Building generation"
		%bp.text = """• Buildings generated through a hierarchy of objects
• Plots -> House foundations -> Walls -> Windows -> Lights
• Objects randomize their own parameters
• The process is modular and easily extensible"""
	else:
		$Label.text = "Generering av byggnader"
		%bp.text = """• Byggnader genereras via en hierarki av objekt
• Tomter -> Fundament -> Väggar -> Fönster -> Ljus
• Objekt slumpar sina egna parametrar
• Processen är modulär och det är lätt att lägga till steg"""
