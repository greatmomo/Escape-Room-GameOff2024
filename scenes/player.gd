extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var min_angle = -80
@export var max_angle = 90

var look_rot : Vector2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	$SpringArm3D.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y

func _unhandled_input(event):
	if event.is_action_pressed("escape"):
		get_tree().quit()

func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x)
		look_rot.x -= (event.relative.y)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)
