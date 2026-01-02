#Herda as funções e variáveis definidas em EnemyBase - lembrar de manter o mesmo nome
#de variáveis, caso tenha novos nós pode ser implementado aqui, sem problemas
extends EnemyBase

@onready var anime: AnimatedSprite2D = $anime
@onready var animator: AnimationPlayer = $"../animator"
#Scale speed é tipico apenas das aves, é a velocidade vertical
@export var velocity_scale_speed := 0.3

func _ready():
	animator.speed_scale = velocity_scale_speed

func _physics_process(_delta: float) -> void:
	pass

func play_anim(anime_name: String) -> void:
	anime.play(anime_name)

func _on_direction_changed() -> void:
	if flip_sprite:
		anime.flip_h = direction == -1

func _on_anime_animation_finished() -> void:
	pass

func stomped() -> void:
	pass
