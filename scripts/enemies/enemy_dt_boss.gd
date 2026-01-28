
extends CharacterBody2D

@onready var anime: AnimatedSprite2D = $anime

@export var life:int = 1

@onready var enemy_hitbox: Area2D = $enemy_hitbox
@onready var enemy_head: Area2D = $enemy_head

@onready var laughter: AudioStreamPlayer2D = $laughter
@onready var hurt: AudioStreamPlayer2D = $hurt
@onready var neutralized: AudioStreamPlayer2D = $neutralized
@onready var life_progress_bar: ProgressBar = $life_bar/progress_bar
@onready var speech_bubble: Node2D = $speech_bubble


var IS_ACTIVE = true
var is_invulnerable = false

var start_position: Vector2
var enemy_scenes: Array = []  # guarda apenas controladores originais

func _ready():
	life_progress_bar.max_value = life
	life_progress_bar.value = life
	
	start_position = global_position
		
	# conecta ao sinal do player
	var player = get_tree().get_first_node_in_group("player") #Pega o player pelo grupo
	if player:
		player.connect("player_has_died", Callable(self, "_on_player_died"))
		
		
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 0, 0) # vermelho
	life_progress_bar.add_theme_stylebox_override("fill", style)

	var bg = StyleBoxFlat.new()
	bg.bg_color = Color(0.2, 0.2, 0.2) # cinza escuro para fundo
	life_progress_bar.add_theme_stylebox_override("background", bg)

func _physics_process(delta: float) -> void:
	speech_bubble.scale.x = self.scale.x * -1 #gira o balão de fala
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = 0
	move_and_slide()

func _on_enemy_head_area_entered(area: Area2D) -> void:
	if not IS_ACTIVE:
		return

	var player := area.get_parent()

	# só reage se for realmente o stomp do player
	if not area.is_in_group("player_stomp"):
		return

	# player quica, mas NÃO leva dano
	player.velocity.y = player.jump_velocity

	# boss leva dano
	if is_invulnerable:
		return

	is_invulnerable = true
	hurt.play()
	anime.play("hurt")
	await anime.animation_finished
	
	life -= 1
	life_progress_bar.value = life

	if life > 0:
		laughter.play()
		anime.play("laught")
		await anime.animation_finished
		await laughter.finished
		anime.play("idle")
	else:#Morre
		IS_ACTIVE = false
		anime.stop()
		remove_from_group("enemies")  # deixa de ser considerado inimigo
		neutralized.play()
		anime.play("hurt")
		life_progress_bar.visible = false
		disable_all_collisions(enemy_head)
		disable_all_collisions(enemy_hitbox)
		eliminate_all_enemies()
		await get_tree().create_timer(3.0).timeout
		#Fala final
		speech_bubble.show_message("Isso não vai ficar assim! Minha corporação é gigante, eu me vingarei.",5.0)

	is_invulnerable = false

func _on_player_died():
	print("Sem reset!")
	

# --- Utilitário: desliga colisões de qualquer nó relevante ---
func disable_all_collisions(node: Node) -> void:
	# Zera camadas/máscaras quando aplicável
	if node is CollisionObject2D:
		node.set_deferred("collision_layer", 0)
		node.set_deferred("collision_mask", 0)

	# Area2D: desliga participação e sinais
	if node is Area2D:
		node.set_deferred("monitoring", false)
		node.set_deferred("monitorable", false)

	# Desativa todas CollisionShape2D filhas
	for child in node.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)

	# Se o próprio nó for uma CollisionShape2D
	if node is CollisionShape2D:
		node.set_deferred("disabled", true)

	# Se o controlador tiver uma CollisionShape2D principal
	# (ex.: $CollisionShape2D diretamente no CharacterBody2D)
	if node == self and has_node("CollisionShape2D"):
		$"CollisionShape2D".set_deferred("disabled", true)
	
	life_progress_bar.visible = false

func eliminate_all_enemies():
	var squad = get_tree().get_nodes_in_group("boss_squad")
	for enemy in squad:
		if is_instance_valid(enemy):
			enemy.queue_free()

func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if Globals.is_player_hurtbox(area):
			area.owner.take_damage(Vector2(-50,-350))
