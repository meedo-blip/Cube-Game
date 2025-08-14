extends Node

@onready var finish_line = $"../FinishLine" as FinishLine
@onready var player: Player = $"../Player"
@onready var ui: UI = $"../UI"
@onready var obstacles: Node = $"../Obstacles"
@onready var player_spawn: Area3D = $"../PlayerSpawn"

var localStorage = LocalStorage.new()

var obstacleScene = preload("res://Scenes/obstacle.tscn")
var spikeBallScene = preload("res://Scenes/spike_ball.tscn")

var num_wins = 0

var best_time = 0.0
var most_wins = 0

const obs_distance_z = 14.0
const min_obs_height = 2.5
const max_obs_height = 5

const obs_start_z = -90
const obs_end_z = 90

const obs_start_x = -4
const obs_end_x = 4

func _ready() -> void:
	# Wait for all nodes to load
	await get_tree().process_frame
	
	finish_line.level_won.connect(on_level_won)
	ui.start_next_level.connect(start_level)
	ui.continue_level.connect(continue_level)
	player.in_void.connect(player_in_void)
	Signals.spike_hit.connect(game_lost)
	
	localStorage.set_password("mafhhamjmamahm")
	
	#localStorage.set_item("most_wins", 0)
	#localStorage.set_item("best_time", 0.0)
	
	var time_best = localStorage.get_item("best_time")
	
	if time_best != '':
		best_time = time_best.to_float() 
	
	ui.set_best_time(best_time)
	
	var wins_most = localStorage.get_item("most_wins")

	if wins_most != '':
		most_wins = wins_most.to_int()
	
	ui.set_most_wins(most_wins)
	
	start_level()
	
func _input(event):
	if event.is_action_pressed("ui_fullscreen"):
		var current_mode = DisplayServer.window_get_mode()
		if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if event is InputEventKey:
		if (event as InputEventKey).keycode == KEY_ESCAPE:
			player.freeze = true
			ui.pause(false)
	
func start_level():
	
	for child in obstacles.get_children():
		child.queue_free()

	var z = obs_start_z
	var switch = true
	
	while z < obs_end_z:
		switch = !switch
		var num = randi_range(1,3)
		for i in range(0, num):
			var x = randf_range(obs_start_x, obs_end_x)
			var y = randf_range(min_obs_height, max_obs_height)
			
			var obs: Obstacle = obstacleScene.instantiate()
			obs.position.x = x
			obs.position.y = y
			obs.position.z = z
			obstacles.add_child(obs)
		
		if switch:	
			var x = randf_range(obs_start_x, obs_end_x)
			var y = randf_range(max_obs_height, max_obs_height + 2)
			
			var obs: SpikeBall = spikeBallScene.instantiate()
			obs.position.x = x
			obs.position.y = y
			obs.position.z = z
			obstacles.add_child(obs)
			
		z += obs_distance_z
		
	player.position = Vector3(player_spawn.position)
	player.freeze = false

func continue_level():
	player.freeze = false
	ui.unpause()

func on_level_won():
	print("Level won")
	player.linear_velocity = Vector3.ZERO
	player.freeze = true
	ui.on_level_finished()
	num_wins += 1
	ui.set_wins(num_wins)
	
	if best_time == 0.0 or ui.time_passed_s < best_time:
		best_time = ui.time_passed_s
		localStorage.set_item("best_time", best_time)
		ui.set_best_time(best_time)
	
	if num_wins > most_wins:
		most_wins = num_wins
		localStorage.set_item("most_wins", most_wins)
		ui.set_most_wins(most_wins)
	

func player_in_void():
	player.position = Vector3(player_spawn.position) 
	player.linear_velocity = Vector3.ZERO

func game_lost():
	num_wins = 0
	ui.set_wins(0)
	player_in_void()
