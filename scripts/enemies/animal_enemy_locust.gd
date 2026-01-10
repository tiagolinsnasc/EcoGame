#Herda as funções e variáveis definidas em EnemyBase - lembrar de manter o mesmo nome
#de variáveis, caso tenha novos nós pode ser implementado aqui, sem problemas
extends EnemyBase

@export var animal_name = "gafanhoto"
@onready var anime: AnimatedSprite2D = $anime
@onready var animator: AnimationPlayer = $animator
#Scale speed é tipico apenas das aves, é a velocidade vertical
@export var velocity_scale_speed := 0.3
@export var anime_horizontal := true

##Permite integrar à missão de plantar árvores (Estágio 3) - se true indica que quando as árvores forem plantadas, os gafanhotos serão eliminados
@export var inside_in_mission := true

func _ready():
	animator.speed_scale = velocity_scale_speed
	
	if anime_horizontal:
		play_anim("flying2")
	else:
		play_anim("flying1")

func _physics_process(_delta: float) -> void:
	if Globals.eliminate_locust() and inside_in_mission:
		die()
	

func play_anim(anime_name: String) -> void:
	if animator.has_animation(anime_name):
		animator.play(anime_name)
	else:
		print("Animação não encontrada:", anime_name)

func _on_direction_changed() -> void:
	if flip_sprite:
		anime.flip_h = direction == -1

func _on_anime_animation_finished() -> void:
	pass

func stomped() -> void:
	pass
	
func die()->void:
	queue_free()
