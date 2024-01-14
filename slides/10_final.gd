extends CenterContainer

func _ready():
	set_text()
	SIGNALS.lang_changed.connect(set_text)

func set_text():
	if SETTINGS.LANG == "en":
		$Label.text = "Questions?"
	else:
		$Label.text = "Frågor?"
