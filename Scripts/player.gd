extends RigidBody3D

class_name Player

const speed = 20
const horizontal_speed = 8
const vertical_speed_increment = .1
const horizonatal_speed_increment = .1
const jump_force = 8

var onGround = true
var input: Vector3 = Vector3.ZERO

func _ready() -> void:
	print("Player start")
	
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if (input.z != 0):
		linear_velocity.z = lerpf(linear_velocity.z, speed , sign(input.z) * vertical_speed_increment)
	if(input.x != 0):
		linear_velocity.x = lerpf(linear_velocity.x, horizontal_speed, sign(input.x) * horizonatal_speed_increment)
		
func _input(event: InputEvent) -> void:
	input.z = Input.get_action_raw_strength("forward") - Input.get_action_raw_strength("slow_down")
	input.x = Input.get_action_raw_strength("left") - Input.get_action_raw_strength("right") 
	
	if Input.is_action_just_pressed("jump") and onGround:
		apply_central_impulse(Vector3(0,jump_force,0))
		onGround = false


func _on_body_entered(body: Node) -> void:
	if body is Floor:
		onGround = true
		
