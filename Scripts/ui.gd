extends CanvasLayer

class_name UI

signal start_next_level

@onready var time_label: Label = %TimeLabel
@onready var finish_line: FinishLine = $"../FinishLine"
@onready var next_level_container: CenterContainer = $NextLevelContainer
@onready var wins_label: Label = $WinsLabel
@onready var most_wins_label: Label = $MostWinsLabel
@onready var best_time_label: Label = $BestTimeLabel

var time_passed_s = 0.0;
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
	next_level_container.visible = true

func _on_next_level_button_pressed() -> void:
	start_next_level.emit()
	time_label.text = "0.00"
	time_passed_s = 0.0
	next_level_container.visible = false
	time_stopped = false

func set_most_wins(most_wins: int):
	most_wins_label.text = "Most Wins:\n" + str(most_wins)
	
func set_best_time(best_time: float):
	best_time_label.text = "Best Time:\n" + str(round(best_time * 100) / 100)
