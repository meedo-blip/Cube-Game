extends RigidBody3D

class_name SpikeBall

@export var fall_down_distance = 15

@onready var player: Player = get_tree().get_root().get_node("Main/Player")
@onready var audio_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	gravity_scale = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distance_between = abs(player.position.z - position.z)
	
	if distance_between < fall_down_distance:
		gravity_scale = 3


func _on_body_entered(body: Node) -> void:
	if body is Floor:
		audio_player_3d.play()
		freeze = true
