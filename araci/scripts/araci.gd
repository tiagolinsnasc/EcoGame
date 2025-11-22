extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0 #Maior = pula mais alto

@onready var animation := $anime as AnimatedSprite2D
@onready var remote_transform: RemoteTransform2D = $remote
@onready var ray_right: RayCast2D = $ray_right
@onready var ray_left: RayCast2D = $ray_left

@export var araci_life := 10

var knockback_vector := Vector2.ZERO

var estado = "idle"
var tempo_pulo = 1.0
var tempo_tiro = 0.0
var cooldown_tiro = 0.5

func _physics_process(delta: float) -> void:
	# Aplica gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Atualiza timers
	if tempo_pulo > 0:
		tempo_pulo -= delta
		if is_on_floor():
			estado = "idle"
	if tempo_tiro > 0:
		tempo_tiro -= delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		estado = "jump"
		tempo_pulo = 0.3
		#print("Pulou")

	# Tiro com tecla R
	if Input.is_action_just_pressed("shot") and tempo_tiro <= 0:
		estado = "shot"
		tempo_tiro = cooldown_tiro
		#print("Atirou com R")
		
		# Ataque curto com F
	if Input.is_action_just_pressed("atack") and tempo_tiro <= 0:
		estado = "atack"
		tempo_tiro = cooldown_tiro #manter mesmo tempo do tiro
		#print("ataque com F")

	# Movimento horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		if is_on_floor() and tempo_pulo <= 0 and tempo_tiro <= 0:
			estado = "run"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and tempo_pulo <= 0 and tempo_tiro <= 0:
			estado = "idle"

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	# Aplica movimento
	move_and_slide()

	# Executa animação baseada no estado
	match estado:
		"jump":
			animation.play("jump")
		"shot":
			animation.play("shot")
		"atack":
			animation.play("atack")
		"run":
			animation.play("run")
		"idle":
			animation.play("idle")


func _on_hurtbox_body_entered(_body: Node2D) -> void:
	#if(_body.is_in_group("enemies")):
		#queue_free()
	if araci_life < 0:
		queue_free()
	else:
		print("Perdeu vida")
		#ray não está colidindo (Suspeito que seja alguma configuração do RayCast2D ver
		#if ray_right.is_colliding():
		if animation.scale.x == 1:
			print("Direita")
			take_damage(Vector2(-200,-200))
		#elif ray_left.is_colliding():
		elif animation.scale.x == -1:
			print("Esquerda")
			take_damage(Vector2(200,-200))

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
	
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	araci_life -= 1
	print("Tomou dano")
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		var knockback_tween = get_tree().create_tween()
		knockback_tween.parallel().tween_property(self,"knockback_vector",Vector2.ZERO,duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation,"modulate",Color(1,1,1,1),duration)
