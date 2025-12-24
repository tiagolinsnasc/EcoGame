extends CharacterBody2D

@onready var anime: AnimatedSprite2D = $anime
@onready var enemy_detec: RayCast2D = $enemy_detect   # radar longo
@onready var ground_check: RayCast2D = $ground_check
@onready var obstacle_check: RayCast2D = $obstacle_check   # curto, usado para ataque

@export var player: CharacterBody2D

# Configurações de movimento
@export var follow_distance: float = 32.0
@export var max_speed: float = 200.0
@export var acceleration: float = 600.0
@export var gravity: float = 900.0
@export var stop_threshold: float = 16.0

# Configurações de combate e raycasts
@export var attack_distance: float = 200.0
@export var jump_force: float = -400.0
@export var max_distance: float = 400.0

# Offsets locais dos raycasts
@export var forward_offset_x: float = 16.0
@export var ground_check_down_y: float = 48.0
@export var obstacle_check_forward_x: float = 24.0

var ground_miss_frames: int = 0
var current_target: Node = null

func _physics_process(delta: float):
	if not player:
		return

	# --- Desaparecer se muito longe ---
	var dist = global_position.distance_to(player.global_position)
	if dist > max_distance:
		visible = false
		return
	else:
		visible = true

	# --- Gravidade ---
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	# --- Se não está atacando, segue o player ---
	if current_target == null:
		var target_x = player.global_position.x - follow_distance * anime.scale.x
		var distance_x = target_x - global_position.x

		if abs(distance_x) > stop_threshold:
			var dir_x = sign(distance_x)
			velocity.x = move_toward(velocity.x, dir_x * max_speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)

		# Virar para o player só quando não está atacando
		if player.global_position.x > global_position.x:
			anime.scale.x = 1
		else:
			anime.scale.x = -1

	# --- Atualizar direção dos RayCasts ---
	_update_raycasts_direction()

	# --- Pulo automático ---
	# --- Pulo automático ---
	if is_on_floor():
		# Sem piso à frente → tolerância antes de pular
		if ground_check and not ground_check.is_colliding():
			ground_miss_frames += 1
			if ground_miss_frames > 3:
				velocity.y = jump_force
				ground_miss_frames = 0
		else:
			ground_miss_frames = 0

		# Obstáculo à frente -> pular, mas só se não for inimigo
		if obstacle_check and obstacle_check.is_colliding():
			var hit = obstacle_check.get_collider()
			if hit and not hit.is_in_group("enemies"):
				velocity.y = jump_force

	# --- Perseguir alvo quando existe ---
	if current_target and is_instance_valid(current_target):
		var dx = current_target.global_position.x - global_position.x
		var dir = sign(dx)
		velocity.x = move_toward(velocity.x, dir * max_speed, acceleration * delta)

		# virar para o inimigo
		if dx > 0:
			anime.scale.x = 1
		else:
			anime.scale.x = -1

		# atacar só quando o RayCast curto detectar
		if obstacle_check and obstacle_check.is_colliding():
			var hit = obstacle_check.get_collider()
			if hit and hit.is_in_group("enemies"):
				_attack(hit)
				current_target = null
				velocity.x = 0

	# --- Idle/Run/Jump automático ---
	if not is_on_floor():
		if anime.animation != "jump":
			anime.play("jump")
	else:
		if abs(velocity.x) > 5:
			if anime.animation != "run":
				anime.play("run")
		else:
			if anime.animation != "idlle":
				anime.play("idlle")

	move_and_slide()


func _input(event):
	if event.is_action_pressed("feroz_companion_attack"):
		_set_target_for_attack()


func _set_target_for_attack():
	# usa o RayCast longo apenas como radar
	if enemy_detec and enemy_detec.is_colliding():
		var hit = enemy_detec.get_collider()
		if hit and hit.is_in_group("enemies"):
			current_target = hit


func _update_raycasts_direction():
	var dir = anime.scale.x

	if enemy_detec:
		enemy_detec.target_position = Vector2(attack_distance * dir, 0)

	if ground_check:
		ground_check.target_position = Vector2(forward_offset_x * dir, ground_check_down_y)

	if obstacle_check:
		obstacle_check.target_position = Vector2(obstacle_check_forward_x * dir, 0)


func _attack(target: Node):
	anime.play("run")
	if target.has_method("take_damage"):
		target.take_damage()
	velocity.x = 0


func _sit_and_bark():
	anime.play("sit_bark")
