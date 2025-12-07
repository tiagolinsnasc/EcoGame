extends CharacterBody2D

@onready var anime: AnimationPlayer = $"../anime"
@onready var animation: AnimatedSprite2D = $animation
@export var enemy_score := 150
@onready var path_follow_hunter: PathFollow2D = $"../path/path_follow_hunter"
@onready var bullet_position: Marker2D = $animation/bullet_position

@onready var player_detect_left: RayCast2D = $player_detect_left
@onready var player_detect_right: RayCast2D = $player_detect_right
@onready var shoot_timer = $shoot_timer  # Timer como filho do Player

const BULLET_SCENE = preload("uid://dl6r8r4yhyxk")

var attacking := false
var original_scale_x: float = 1.0
var player: Node2D = null   # referência ao player detectado


func _ready() -> void:
	anime.play("hunter_patrol")
	animation.play("walk")
	shoot_timer.wait_time = 1.0
	shoot_timer.one_shot = false   # repete automaticamente
	shoot_timer.stop()             # começa parado 
	shoot_timer.timeout.connect(_on_shoot_timer_timeout) #ADD
	
#Transferido para o script do hitbox
#func _on_hitbox_hunter_body_entered(_body: Node2D) -> void:
	#anime.pause() #Pausa a nimação do AnimationPlay, evita que o enemy se mova na execução do hurt
	#animation.play("hurt")

func _on_animation_animation_finished() -> void:
	if animation.animation == "hurt":
		queue_free()
		Globals.score += enemy_score


#Cria uma instância da bala (BULLET)
func shoot_bullet():
	animation.play("shot")
	# espera 2 segundos antes de criar a bala
	await get_tree().create_timer(0.5).timeout
	
	# checa se ainda está atacando
	if not attacking:
		return
		
	var bullet_instance = BULLET_SCENE.instantiate()
	# direção baseada na orientação do Marker2D (eixo X global)
	var dir := bullet_position.global_transform.x.normalized()
	bullet_instance.direction = dir
	add_child(bullet_instance)
	#Posição da bala
	bullet_instance.global_position = bullet_position.global_position


func _process(_delta):
	var sees_player = false
	var collider = null
	if player_detect_left.is_colliding():
		collider = player_detect_left.get_collider()
		if collider != null and collider.name == "Araci":
			player = collider
			sees_player = true
	
	if player_detect_right.is_colliding():
		collider = player_detect_right.get_collider()
		if collider != null and collider.name == "Araci":
			player = collider
			sees_player = true
	
	if sees_player and not attacking:
		start_attack()
		#print("Iniciou o ataque!")
	elif not sees_player and attacking:
		stop_attack()
		#print("Parou o ataque!")

func start_attack():
	attacking = true
	anime.pause()              # pausa patrulha
	
	path_follow_hunter.set_process(false)

	# virar para Araci (sprite + patrulha)
	if player.global_position.x < global_position.x:
		animation.scale.x = -abs(original_scale_x)  # vira sprite para esquerda
	else: 
		animation.scale.x = abs(original_scale_x)   # vira sprite para direita
	
	animation.play("idlle")   # ou "shot" quando for atirar
	shoot_timer.start()       # começa a atirar
	#Atira
	#shoot_bullet()

func stop_attack():
	attacking = false
	shoot_timer.stop()         # para de atirar
	
	# volta para o lado original
	animation.scale.x = original_scale_x
	path_follow_hunter.set_process(true)   # retoma movimento do PathFollow
	
	anime.play("hunter_patrol")# volta a andar
	animation.play("walk")        # volta a animação visual de andar
	
func _on_shoot_timer_timeout():
	if attacking:
		shoot_bullet()
