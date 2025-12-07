extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0 #Maior = pula mais alto

@onready var animation := $anime as AnimatedSprite2D
@onready var remote_transform: RemoteTransform2D = $remote
@onready var ray_right: RayCast2D = $ray_right
@onready var ray_left: RayCast2D = $ray_left
@onready var araci_start_position: Marker2D = $"../araci_start_position"


var knockback_vector := Vector2.ZERO
var knockback_power := 20

var estado = "idle"
var tempo_pulo = 1.0
var tempo_tiro = 0.0
var cooldown_tiro = 0.5

signal player_has_died()

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
	
#	Ação do playe em plataformas que caem
	for plataforms in get_slide_collision_count():
		var collision = get_slide_collision(plataforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

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
		"hurt":
			animation.play("hurt")


func _on_hurtbox_body_entered(body: Node2D) -> void:

	var knockback = Vector2((global_position.x - body.global_position.x)*knockback_power,-200)
	take_damage(knockback)

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
	
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	#Deve estar ativo ao encostar em inimigos e espinhas
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		queue_free()
		emit_signal("player_has_died")
		
	#print("Tomou dano")
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		var knockback_tween = get_tree().create_tween()
		knockback_tween.parallel().tween_property(self,"knockback_vector",Vector2.ZERO,duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation,"modulate",Color(1,1,1,1),duration)

#Lida com a queda em áreas de morte (ressurge no começo, ou no último chakpoint)
func handle_death_zone():
	if Globals.player_life > 0:
		Globals.player_life -=1
		visible = false
		set_physics_process(false)
		await get_tree().create_timer(1.0).timeout
		Globals.respaw_player()
		#global_position = araci_start_position.global_position
		visible = true
		set_physics_process(true)
	else:
		visible = false
		await get_tree().create_timer(0.5).timeout
