extends CharacterBody2D

@export var SPEED = 700.0
const JUMP_VELOCITY = -400.0

@onready var wall_detector: RayCast2D = $wall_detector
@onready var texture: AnimatedSprite2D = $texture

var direction := 1

@export var enemy_score = 100

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if wall_detector.is_colliding():
		#print("Lenhador Colidiu")
		direction *= -1
		wall_detector.scale.x *= -1
	
	if direction == -1:
		texture.flip_h = true
	else:
		texture.flip_h = false
	
	velocity.x = direction * SPEED * delta

	move_and_slide()

#Quando a animação de hurt terminar
#Lembrar que o acesso as animação é via AnimatedSprite (já que as animações foram feitas nesse objeto)
# e não AnimationPlayer
func _on_texture_animation_finished() -> void:
	if texture.animation == "hurt":
		Globals.score += enemy_score
		queue_free()

#Para a animação do inimigo (evita que a animação de hurt ocorra com o personagem se movendo)
func stop():
	velocity = Vector2.ZERO
	move_and_slide()
