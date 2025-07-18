extends Node

@onready var finish_line = $"../FinishLine" as FinishLine
@onready var player: Player = $"../Player"
@onready var ui: UI = $"../UI"

func _ready() -> void:
	finish_line.level_won.connect(on_level_won)

func on_level_won():
	print("Level won")
	player.linear_velocity = Vector3.ZERO
	player.freeze = true
	ui.on_level_finished()
