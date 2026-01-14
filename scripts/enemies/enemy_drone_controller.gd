extends EnemyBase

@onready var anime: AnimatedSprite2D = $anime
# -1 = esquerda, 1 = direita
@export var start_direction: int = -1
@onready var enemy_hitbox: Area2D = $enemy_hitbox
@onready var enemy_head: Area2D = $enemy_head
@onready var body: CollisionShape2D = $body

func _ready():
	pass

# inimigo fixo, não se move
func _physics_process(_delta: float) -> void:
	pass

func play_anim(anime_name: String) -> void:
	anime.play(anime_name)

func _on_direction_changed() -> void:
	if flip_sprite:
		anime.flip_h = direction == -1

func _on_anime_animation_finished() -> void:
	on_anim_finished(anime.animation)

func take_damage():
	Globals.give_points_to_player(enemy_score, global_position, self)
	die()

func die():
	# avisa todos os filhos drones para morrerem
	for child in get_children():
		if child.has_method("die"):
			child.die()

	# para garantir que os drones tenham tempo de tocar a animação
	# desabilita colisões
	disable_collisions(enemy_head)
	disable_collisions(enemy_hitbox)	
	anime.visible = false 
	body.set_deferred("disabled", true)
	
	await get_tree().create_timer(3.0).timeout
	queue_free()

##Desabilita todas as colisões em um nó
func disable_collisions(node: Node) -> void:
	# Area2D
	if node is Area2D:
		node.set_deferred("monitoring", false)
		node.set_deferred("monitorable", false)
		node.set_deferred("collision_layer", 0)
		node.set_deferred("collision_mask", 0)
		# desativa shapes filhas
		for child in node.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", true)

	# PhysicsBody2D (CharacterBody2D, RigidBody2D, StaticBody2D)
	elif node is PhysicsBody2D:
		node.set_deferred("collision_layer", 0)
		node.set_deferred("collision_mask", 0)
		for child in node.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", true)

	# CollisionShape2D direto
	elif node is CollisionShape2D:
		node.set_deferred("disabled", true)
