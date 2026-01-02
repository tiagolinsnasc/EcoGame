
extends EnemyBase

@export var SPEED = 700.0

@onready var anime: AnimatedSprite2D = $anime


var is_attacking := false


func _physics_process(delta: float) -> void:

	#Se está atacando
	if is_attacking:
		# Se o player saiu do alcance → parar ataque
		if not _player_in_range():
			_stop_attack()
		else:
			velocity.x = 0
			move_and_slide()
		return

	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Detecta parede
	if wall_detector.is_colliding():
		direction *= -1
		_update_detectors()

	# Detecta borda
	if not ground_detector.is_colliding():
		direction *= -1
		_update_detectors()

	#Detecta Player
	if _player_in_range():
		_start_attack()

	# Atualiza animação
	anime.flip_h = direction == -1

	# Movimento normal
	velocity.x = direction * SPEED * delta
	move_and_slide()


#Verifica se o player está no RayCast
func _player_in_range() -> bool:
	if player_detector.is_colliding():
		var hit = player_detector.get_collider()
		if hit != null and hit.name == "Araci":
			return true
	return false


#Inicia ataque
func _start_attack():
	if is_attacking:
		return

	is_attacking = true
	anime.play("attack")

	#Ativa hitbox
	attack_shape.disabled = false


#Para ataque e volta a andar
func _stop_attack():
	is_attacking = false
	attack_shape.disabled = true
	anime.play("walk")


#Atualiza direção dos RayCasts (hitbox não vira mais)
func _update_detectors():
	wall_detector.target_position.x = abs(wall_detector.target_position.x) * direction
	ground_detector.target_position.x = abs(ground_detector.target_position.x) * direction
	player_detector.target_position.x = abs(player_detector.target_position.x) * direction


#Quando animação termina
func _on_texture_animation_finished() -> void:

	if anime.animation == "hurt":
		Globals.score += enemy_score
		queue_free()

	if anime.animation == "attack":
		attack_shape.disabled = true
		is_attacking = false
		anime.play("walk")


#Player levou dano
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == "Araci":
		print("Player levou dano")
		var direction_jump: float = sign(body.global_position.x - global_position.x)  # +1 ou -1
		var knockback: Vector2 = Vector2(400 * direction_jump, -150)
		body.take_damage(knockback)

		
func stop() -> void:
	velocity = Vector2.ZERO
	is_attacking = false

	if attack_shape:
		attack_shape.disabled = true

	# opcional: garante que não volta a tocar walk sozinho
	anime.play("hurt")
