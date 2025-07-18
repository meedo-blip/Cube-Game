extends CanvasLayer

class_name UI

@onready var time_label: Label = %TimeLabel
@onready var finish_line: FinishLine = $"../FinishLine"
@onready var next_level_container: CenterContainer = $NextLevelContainer

var time_passed_s = 0;
var time_stopped = false

func _ready() -> void:
	next_level_container.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not time_stopped:
		time_passed_s += delta
		time_label.text = str(round(time_passed_s * 100) / 100) 

func on_level_finished():
	time_stopped = true
	#next_level_container.visible = true

func _on_next_level_button_pressed() -> void:
	print("Button pressed")
