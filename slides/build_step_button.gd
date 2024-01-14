extends Button

func _on_pressed():
	SIGNALS.next_build_step.emit()
