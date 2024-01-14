extends Node

@export var slides:Array[PackedScene]

var current_ind = 0
var current_slide:Node = null
var in_slideshow = true

func _ready():
	randomize() # Seed rng
	goto_slide(current_ind)
	#switch_scene()

func _input(event):
	if event.is_action_released("next_slide"):
		next_slide()
	elif event.is_action_released("prev_slide"):
		prev_slide()
	elif event.is_action_released("switch_scene"):
		switch_scene()

func switch_scene():
	if in_slideshow:
		$slideshow.visible = false
		$slide_progress.visible = false
		$zawarudo.visible = true
		$zawarudo.show_ui()
		SIGNALS.hide_build_test.emit()
		in_slideshow = false
	else:
		$slideshow.visible = true
		$slide_progress.visible = true
		$zawarudo.visible = false
		$zawarudo.hide_ui()
		SIGNALS.show_build_test.emit()
		in_slideshow = true

func next_slide():
	current_ind += 1
	if current_ind >= slides.size():
		current_ind = 0
	goto_slide(current_ind)

func prev_slide():
	current_ind -= 1
	if current_ind < 0:
		current_ind = slides.size() - 1
	goto_slide(current_ind)

func goto_slide(ind):
	if current_slide != null:
		current_slide.queue_free()
	var new_slide = slides[ind].instantiate()
	$"%slide_container".add_child(new_slide)
	current_slide = new_slide
	current_ind = ind
	
	$slide_progress.value = float(current_ind) / float(slides.size()-1)

func _on_lang_select_item_selected(index):
	if index == 0:
		SETTINGS.LANG = "en"
	else:
		SETTINGS.LANG = "se"
	SIGNALS.lang_changed.emit()
