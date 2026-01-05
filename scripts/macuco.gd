extends CharacterBody2D

@onready var wall_detector: RayCast2D = $wall_detector
@onready var animation: AnimatedSprite2D = $animation
@onready var ground_detector: RayCast2D = $ground_detector

const SPEED = 600.0
const JUMP_VELOCITY = -400.0
var direction := 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Detecta parede
	if wall_detector.is_colliding():
		direction *= -1
		_update_detectors()
		animation.flip_h = direction == -1

	# Detecta borda
	if not ground_detector.is_colliding():
		direction *= -1
		_update_detectors()
		animation.flip_h = direction == -1

	velocity.x = direction * SPEED * delta
	move_and_slide()
	
## Ajusta o RayCast para sempre apontar para a direção atual do inimigo
func _update_detectors():
	wall_detector.target_position.x = abs(wall_detector.target_position.x) * direction
	ground_detector.target_position.x = abs(ground_detector.target_position.x) * direction
