#Herda as funções e variáveis definidas em EnemyBase - lembrar de manter o mesmo nome
#de variáveis, caso tenha novos nós pode ser implementado aqui, sem problemas
extends EnemyBase

@onready var anime: AnimatedSprite2D = $anime

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	if not is_on_floor():
		velocity += get_gravity() * speed * delta
		$"../../maina3/path2D/path_follow2D".progress += speed * delta

func play_anim(anime_name: String) -> void:
	anime.play(anime_name)

func _on_direction_changed() -> void:
	if flip_sprite:
		anime.flip_h = direction == -1

func _on_anime_animation_finished() -> void:
	pass

func stomped() -> void:
	pass
