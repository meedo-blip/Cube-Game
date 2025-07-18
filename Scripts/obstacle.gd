extends RigidBody3D

@export var player: RigidBody3D
@export var fall_down_distance = 40 

@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var audio_player_3d = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_z_vector = Vector3(0, 0, player.position.z)
	var obstacle_z_vector = Vector3(0, 0, position.z)
	var distance_between = player_z_vector.distance_to(obstacle_z_vector);
	
	if distance_between < fall_down_distance:
		gravity_scale = 1

func _on_body_entered(body: Node) -> void:
	if body is Floor:
		gpu_particles_3d.emitting = false;
		audio_player_3d.play();
		
