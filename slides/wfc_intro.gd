extends VBoxContainer

func _ready():
	set_text()
	SIGNALS.lang_changed.connect(set_text)

func set_text():
	if SETTINGS.LANG == "en":
		%bp.text = """• Fairly recent algorithm for random generation 
• Usage: procedural textures and models, video game level generation
• The term comes from quantum mechanics, where a wave function can exist in a superposition of several states until it is observed
• Alternatively: A Markov chain in multiple dimensions"""
	else:
		%bp.text = """• Ganska ny algoritm för slumpgenerering
• Användning: Procedurella texturer och modeller, nivågenerering i spel
• Begreppet kommer från kvantmekaniken, där en vågfunktion kan existera i en superposition av flera kvanttillstånd tills den observeras
• Alternativt: En Markovkedja i flera dimensioner"""
