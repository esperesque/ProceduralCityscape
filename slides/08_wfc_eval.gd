extends VBoxContainer

func _ready():
	set_text()
	SIGNALS.lang_changed.connect(set_text)

func set_text():
	if SETTINGS.LANG == "en":
		$Label.text = "Pros and cons of WFC"
		%bp.text = """• Grid-based
• Rules only apply locally - nonsensical on a macro scale
• Good for: Video game level generation, synthetic motifs
• Bad for: Realistic terrain generation"""
	else:
		$Label.text = "För- och nackdelar med WFC"
		%bp.text = """• Rutnät-baserad
• Regler endast lokalt - nonsens på makronivå
• Bra för: Nivågenerering i spel, syntetiska motiv
• Dålig för: Realistisk terränggenerering"""
