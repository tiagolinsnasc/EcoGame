extends CharacterBody2D
class_name EnemyBase

##SCRIPT BASE PARA TODOS OS INIMIGOS (manter os mesmos nomes de componentes)

@export var speed := 700.0
@export var enemy_score := 100
@export var enemy_life := 1
@export var flip_sprite := true

#Permite criar apenas se houver esses nós no enemy
@onready var wall_detector := get_node_or_null("wall_detector")
@onready var ground_detector := get_node_or_null("ground_detector")

var direction := 1
var is_dead := false

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Detecta parede
	if wall_detector.is_colliding():
		_reverse_direction()

	# Detecta borda
	if not ground_detector.is_colliding():
		_reverse_direction()

	velocity.x = direction * speed * delta
	move_and_slide()

func _reverse_direction() -> void:
	direction *= -1
	_update_detectors()
	_on_direction_changed()

func _update_detectors() -> void:
	wall_detector.target_position.x = abs(wall_detector.target_position.x) * direction
	ground_detector.target_position.x = abs(ground_detector.target_position.x) * direction

##Chamado quando o inimigo vira (para flip de sprite)
func _on_direction_changed() -> void:
	# vazio — cada inimigo implementa se quiser
	pass

##Stomp do player
func stomped() -> void:
	take_damage()

# ✅ Dano genérico
func take_damage() -> void:
	if is_dead:
		return

	is_dead = true
	play_anim("hurt")

##Animação finalizada
func on_anim_finished(anim_name: String) -> void:
	if anim_name == "hurt":
		#TODO: chamar o método (Problema, alguns scripts são chamados no nó2d e não no nó principal)
		Globals.add_score(enemy_score)
		queue_free()

##Função genérica de animação (cada inimigo implementa)
func play_anim(_anime_name: String) -> void:
	pass

##StompBox do player
func _on_enemy_head_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player_stomp"):
		return

	var player := area.get_parent()
	player.velocity.y = player.jump_velocity
	stomped()
