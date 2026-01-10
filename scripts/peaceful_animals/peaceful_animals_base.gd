extends CharacterBody2D
class_name PeacefulAnimalsBase
#Já possui o animal_name, para uso de informações

@onready var animation: AnimatedSprite2D = $anime

#Permite criar apenas se houver esses nós no enemy
@onready var wall_detector := get_node_or_null("wall_detector")
@onready var ground_detector := get_node_or_null("ground_detector")

##O nome deve ser idêntico ao do dicinário de informações em Araci
@export var animal_name = ""

@export var SPEED = 900.0
@export var JUMP_VELOCITY = -400.0
var direction := 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Detecta parede
	if is_instance_valid(wall_detector) and wall_detector.is_colliding():
		direction *= -1
		_update_detectors()
		animation.flip_h = direction == -1

	# Detecta borda
	if is_instance_valid(ground_detector) and not ground_detector.is_colliding():
		direction *= -1
		_update_detectors()
		animation.flip_h = direction == -1

	velocity.x = direction * SPEED * delta
	move_and_slide()
	
## Ajusta o RayCast para sempre apontar para a direção atual do inimigo
func _update_detectors():
	wall_detector.target_position.x = abs(wall_detector.target_position.x) * direction
	ground_detector.target_position.x = abs(ground_detector.target_position.x) * direction

		
