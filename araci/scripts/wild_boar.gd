extends CharacterBody2D
@onready var wall_detector: RayCast2D = $wall_detector
@onready var animation: AnimatedSprite2D = $animation
@onready var ground_detector: RayCast2D = $ground_detector

const SPEED = 900.0
const JUMP_VELOCITY = -400.0
var direction := 1

func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		ground_detector.scale.x *= -1
		#print("Javalí colidiu com a parede! Scala chão:",ground_detector.scale.x,", Escala wall:",wall_detector.scale.x)
		animation.flip_h = direction == -1
		
	if not ground_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		ground_detector.scale.x *= -1
		#print("Onça no precipício!")
		animation.flip_h = direction == -1
	
	velocity.x = direction * SPEED * delta
	move_and_slide()
