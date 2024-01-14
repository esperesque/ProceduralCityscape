extends SpinBox

func _on_value_changed(value):
	SETTINGS.DENSITY = float(value) / 100.0
