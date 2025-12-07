extends CharacterBody2D
@onready var wall_detector: RayCast2D = $wall_detector
@onready var animation: AnimatedSprite2D = $animation

const SPEED = 900.0
const JUMP_VELOCITY = -400.0
var direction := 1

func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if wall_detector.is_colliding():
		print("Javali colidiu!")
		direction *= -1
		wall_detector.scale.x *= -1

	if direction == -1:
		animation.flip_h = true
	else:
		animation.flip_h = false
		
	velocity.x = direction * SPEED * delta
	
	move_and_slide()
