extends CanvasLayer

class_name UI

signal start_next_level
signal continue_level

@onready var time_label: Label = %TimeLabel
@onready var finish_line: FinishLine = $"../FinishLine"
@onready var menu_container: CenterContainer = $MenuContainer
@onready var wins_label: Label = $WinsLabel
@onready var most_wins_label: Label = $MostWinsLabel
@onready var best_time_label: Label = $BestTimeLabel
@onready var audio_button: TextureButton = $AudioButton
@onready var continue_button: Button = %ContinueButton

var AUDIO_ON: Texture2D = ImageTexture.create_from_image(Image.load_from_file("res://Assets/Images/audio-on.png"))
var AUDIO_OFF: Texture2D =  ImageTexture.create_from_image(Image.load_from_file("res://Assets/Images/audio-off.png"))

var time_passed_s = 0.0;
var time_stopped = false
var is_muted = false

func _ready() -> void:
	menu_container.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not time_stopped:
		time_passed_s += delta
		time_label.text = str(round(time_passed_s * 100) / 100) 

func on_level_finished():
	pause(true)
		
func set_most_wins(most_wins: int):
	most_wins_label.text = "Most Wins:\n" + str(most_wins)
	
func set_best_time(best_time: float):
	best_time_label.text = "Best Time:\n" + str(round(best_time * 100) / 100)

func set_wins(wins: int):
	wins_label.text = "Wins:\n" + str(wins)

func pause(is_win: bool):
	time_stopped = true
	menu_container.visible = true
	
	continue_button.visible = !is_win
	
func unpause():
	time_stopped = false
	menu_container.visible = false

func _on_next_level_button_pressed() -> void:
	start_next_level.emit()
	time_label.text = "0.00"
	time_passed_s = 0.0
	unpause()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_audio_button_pressed() -> void:
	print("hi")
	is_muted = !is_muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), is_muted)
	if is_muted:
		audio_button.texture_normal = AUDIO_OFF
	else:
		audio_button.texture_normal = AUDIO_ON

func _on_continue_button_pressed() -> void:
	continue_level.emit()
