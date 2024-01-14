extends VBoxContainer

var highlight_color = Color.GOLDENROD
var step = 0
@onready var step_labels = [%step0, %step1, %step2, %step3, %step4, %step5]

func _ready():
	SIGNALS.next_build_step.connect(next_step)
	%step0.modulate = highlight_color
	set_text()
	SIGNALS.lang_changed.connect(set_text)

func next_step():
	step += 1
	if step == 6:
		step = 0
		
	for s in step_labels:
		s.modulate = Color.WHITE
	
	step_labels[step].modulate = highlight_color
	
func set_text():
	if SETTINGS.LANG == "en":
		$Label.text = "Building generation - step by step"
		%step0.text = "0: Empty plot"
		%step1.text = "1: Draw rectangle"
		%step2.text = "2: Adjust corners"
		%step3.text = "3: Draw walls"
		%step4.text = "4: Generate extrusions"
		%step5.text = "5: Draw roof"
		$HBoxContainer/bulletpoints/build_step_button.text = "Next step"
	else:
		$Label.text = "Generering av byggnader - Steg för steg"
		%step0.text = "0: Tom tomt"
		%step1.text = "1: Rita rektangel"
		%step2.text = "2: Justera hörn"
		%step3.text = "3: Rita väggar"
		%step4.text = "4: Generera utbyggnader"
		%step5.text = "5: Rita tak"
		$HBoxContainer/bulletpoints/build_step_button.text = "Nästa steg"
