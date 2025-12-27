extends CharacterBody2D

# ============================================================
# CONFIGURAÇÕES DE MOVIMENTO E PULO (EDITÁVEIS NO INSPECTOR)
# ============================================================

## Altura máxima do pulo
@export var jump_height := 120.0
## Fator de multiplicação para o superpulo
@export var superjump_factor := 3

## Tempo até o topo do pulo                 
@export var max_time_to_peak := 0.5            
## Tempo da queda
@export var max_time_to_fall := 0.6

## Velocidade máxima no chão
@export var max_speed := 150.0                  
@export var acceleration := 2000.0              # Aceleração horizontal
@export var deceleration := 1800.0              # Desaceleração horizontal
@export var apex_bonus := 80.0                  # Bônus de controle no topo do pulo

##Tempo para pular da plataforma - adiciona um tempo extra para reação depois que a plataforma cai
@export var coyote_time := 0.12                 # Tempo para pular após sair da plataforma
## Tempo para registrar o pulo antes de tocar o chão
@export var jump_buffer_time := 0.12            

# ============================================================
# CANCEL WINDOW - Desativa o ataque quando inicia a animação e logo após pula
# ============================================================

var can_cancel := false
@export var cancel_window := 0.15   ## tempo para cancelar ataque/tiro com pulo ou movimento

# ============================================================
# VARIÁVEIS INTERNAS DE FÍSICA
# ============================================================

var gravity: float = 0.0
var fall_gravity: float = 0.0
var jump_velocity: float = 0.0

var coyote_timer: float = 0.0
var jump_buffer: float = 0.0

# ============================================================
# OUTRAS VARIÁVEIS
# ============================================================

@onready var animation := $anime as AnimatedSprite2D
@onready var remote_transform: RemoteTransform2D = $remote
@onready var ray_right: RayCast2D = $ray_right
@onready var ray_left: RayCast2D = $ray_left
@onready var araci_start_position: Marker2D = $"../araci_start_position"

var knockback_vector := Vector2.ZERO
var knockback_power := 20

var estado := "idle"
var tempo_pulo: float = 0.0
var tempo_tiro: float = 0.0
var cooldown_tiro: float = 0.5

signal player_has_died()

# ============================================================
# DANO, INVENCIBILIDADE E KNOCKBACK
# ============================================================

var invincible: bool = false          # impede dano repetido
var invincible_time: float = 0.4      # tempo de invencibilidade após levar dano
var is_hurt: bool = false             # trava o movimento durante knockback

# ============================================================
# CÁLCULO DE FÍSICA DO PULO
# ============================================================

func _ready() -> void:
	# Gravidade para subir
	gravity = (2.0 * jump_height) / pow(max_time_to_peak, 2.0)
	# Gravidade para cair (um pouco maior, queda mais “pesada”)
	fall_gravity = (2.0 * jump_height) / pow(max_time_to_fall, 2.0)
	# Velocidade inicial do pulo (negativa = para cima)
	jump_velocity = -sqrt(2.0 * gravity * jump_height)
	#Atualiza a instância de Araci em globals
	Globals.araci = self


# ============================================================
# LOOP PRINCIPAL DE FÍSICA
# ============================================================

func _physics_process(delta: float) -> void:
	var on_floor := is_on_floor()

	# --------------------------------------------------------
	# ✅ BLOQUEIA MOVIMENTO DURANTE KNOCKBACK
	# --------------------------------------------------------
	if is_hurt:
		velocity = knockback_vector
		move_and_slide()
		return

	# --------------------------------------------------------
	# ATUALIZAÇÃO DE TIMERS (TIRO E JANELAS DE PULO)
	# --------------------------------------------------------
	if tempo_tiro > 0.0:
		tempo_tiro -= delta

	# Coyote time
	if on_floor:
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# Jump buffer
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer = jump_buffer_time
	else:
		jump_buffer -= delta

	## --------------------------------------------------------
	## PULO (COYOTE + BUFFER) E ESTADO "JUMP"
	## Cancel window permite cancelar ataque/tiro com pulo
	## --------------------------------------------------------
	#if jump_buffer > 0.0 and (coyote_timer > 0.0 or can_cancel):
		#velocity.y = jump_velocity
		#jump_buffer = 0.0
		#coyote_timer = 0.0
		#estado = "jump"
		#tempo_pulo = 0.1   # pequeno tempo para segurar o estado de pulo
#
	#if tempo_pulo > 0.0:
		#tempo_pulo -= delta

	# --------------------------------------------------------
# PULO (COYOTE + BUFFER) E ESTADO "JUMP"
# --------------------------------------------------------
	if jump_buffer > 0.0 and (coyote_timer > 0.0 or can_cancel):
		#Macanimsmo do superpulo pular x vezes mais quando segura o W + BARRA
		# Se W (superjump) estiver pressionado e flag ativa
		if Input.is_action_pressed("call_superjump") and Globals.flag_pw_superjump:
			#print("Superpulo")
			var super_height = jump_height * superjump_factor  # aumenta altura do pulo
			var super_velocity = -sqrt(2.0 * gravity * super_height)
			velocity.y = super_velocity
		else:
			# Pulo normal
			velocity.y = jump_velocity

		jump_buffer = 0.0
		coyote_timer = 0.0
		estado = "jump"
		tempo_pulo = 0.1

	# --------------------------------------------------------
	# GRAVIDADE COM PULO VARIÁVEL
	# --------------------------------------------------------
	if velocity.y < 0.0 and not Input.is_action_pressed("ui_accept"):
		# Soltou o botão enquanto sobe → pulo menor
		velocity.y += gravity * 1.5 * delta
	elif velocity.y > 0.0:
		# Caindo
		velocity.y += fall_gravity * delta
	else:
		# Subindo normalmente
		velocity.y += gravity * delta

	# --------------------------------------------------------
	# MOVIMENTO HORIZONTAL
	# --------------------------------------------------------
	var input_dir := Input.get_axis("ui_left", "ui_right")

	# Apex bonus → mais controle no topo do pulo
	var apex: float = clamp(abs(velocity.y) / 200.0, 0.0, 1.0)
	var apex_speed: float = lerp(apex_bonus, 0.0, apex)

	if input_dir != 0.0:
		velocity.x = move_toward(velocity.x, input_dir * (max_speed + apex_speed), acceleration * delta)
		animation.scale.x = input_dir

		# Cancel window: movimento cancela ataque/tiro
		if can_cancel and estado in ["shoot", "atack"]:
			estado = "run"

		# Só define run se não estiver em ações prioritárias
		if on_floor and estado not in ["shoot", "atack", "hurt", "jump"]:
			estado = "run"
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)

		# Se está no chão, parado e não está em outra ação, fica idle
		if on_floor and estado not in ["shoot", "atack", "hurt", "jump"]:
			estado = "idle"

	# --------------------------------------------------------
	# TIRO E ATAQUE
	# Agora com cancel window
	# --------------------------------------------------------
	if Input.is_action_just_pressed("shoot") and tempo_tiro <= 0.0:
		estado = "shoot"
		tempo_tiro = cooldown_tiro
		_start_cancel_window()

	if Input.is_action_just_pressed("atack") and tempo_tiro <= 0.0:
		estado = "atack"
		tempo_tiro = cooldown_tiro
		_start_cancel_window()

	# --------------------------------------------------------
	# APLICA KNOCKBACK (apenas visual, o real está no bloco is_hurt)
	# --------------------------------------------------------
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	# --------------------------------------------------------
	# MOVIMENTO FINAL
	# --------------------------------------------------------
	move_and_slide()

	on_floor = is_on_floor()  # atualiza após o movimento

	# --------------------------------------------------------
	# CORRIGE ESTADO APÓS ATERRISSAR
	# --------------------------------------------------------
	if on_floor and estado == "jump":
		if abs(velocity.x) > 10.0:
			estado = "run"
		else:
			estado = "idle"

	# --------------------------------------------------------
	# PLATAFORMAS QUE CAEM
	# --------------------------------------------------------
	for i: int in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(i)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

	# --------------------------------------------------------
	# ANIMAÇÕES BASEADAS NO ESTADO
	# --------------------------------------------------------
	match estado:
		"jump":
			animation.play("jump")
		"shoot":
			animation.play("shoot")
		"atack":
			animation.play("atack")
		"run":
			animation.play("run")
		"idle":
			animation.play("idle")
		"hurt":
			animation.play("hurt")


# ============================================================
# CANCEL WINDOW - Cancela o tiro quando pula
# ============================================================

func _start_cancel_window() -> void:
	can_cancel = true
	await get_tree().create_timer(cancel_window).timeout
	can_cancel = false


# ============================================================
# ✅ DANO, KNOCKBACK E INVENCIBILIDADE (AJUSTADO)
# ============================================================

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25) -> void:
	# ✅ evita dano repetido
	if invincible:
		return

	invincible = true
	is_hurt = true
	estado = "hurt"
	#print("Chamou take damage, deveria mudar de cor")
	# ✅ reduz vida
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		queue_free()
		emit_signal("player_has_died")

	# ✅ aplica knockback
	knockback_vector = knockback_force

	# Tween para suavizar knockback e piscada
	var tween: Tween = get_tree().create_tween()

	# Knockback suaviza em paralelo
	tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)

	# Cor: primeiro vermelho, depois branco (sequencial)
	animation.modulate = Color(1, 0, 0) # já começa vermelho
	tween.tween_property(animation, "modulate", Color(1, 1, 1), 0.1)
	tween.tween_property(animation, "modulate", Color(1, 0, 0), 0.1)
	tween.tween_property(animation, "modulate", Color(1, 1, 1), 0.1)
	tween.tween_property(animation, "modulate", Color(1, 0, 0), 0.1) # piscada extra
	tween.tween_property(animation, "modulate", Color(1, 1, 1), 0.1) # volta ao normal

	# ✅ espera o knockback acabar
	await get_tree().create_timer(duration).timeout
	is_hurt = false

	# ✅ volta ao estado correto
	if is_on_floor():
		if abs(velocity.x) > 10:
			estado = "run"
		else:
			estado = "idle"
	else:
		estado = "jump"

	# ✅ espera invencibilidade acabar
	await get_tree().create_timer(invincible_time).timeout
	invincible = false


# ============================================================
# OUTROS
# ============================================================

func handle_death_zone() -> void:
	if Globals.player_life > 0:
		Globals.player_life -= 1
		visible = false
		set_physics_process(false)
		await get_tree().create_timer(1.0).timeout
		Globals.respaw_player()
		visible = true
		set_physics_process(true)
	else:
		visible = false
		await get_tree().create_timer(0.5).timeout

func follow_camera(camera: Node2D) -> void:
	remote_transform.remote_path = camera.get_path()

func _on_anime_animation_finished() -> void:
	if estado in ["shoot", "atack"]:
		# Se estiver andando, volta para run
		if abs(velocity.x) > 10 and is_on_floor():
			estado = "run"
		else:
			estado = "idle"

func _on_hurtbox_body_entered(body: Node2D) -> void:
		#print("Araci levou dano") 
		var direction_jump:float = sign(global_position.x - body.global_position.x) 
		var knockback:Vector2 = Vector2(600 * direction_jump, -350) 
		take_damage(knockback)

#Requer configuração dos grupos (Permite dano quando em uma área especificada em groups
func _on_hurtbox_area_entered(area: Area2D) -> void:
	# Se a área for uma armadilha recorrente
	#Quando tem armadilhas de dano recorrente (não desarmam)
	#Quando a armadilha desarma após o primeiro dano o script que controla o dano é no script da armadilha
	if area.is_in_group("appellant traps"):
		var direction_jump:float = sign(global_position.x - area.global_position.x)
		var knockback:Vector2 = Vector2(600 * direction_jump, -350)
		take_damage(knockback)
