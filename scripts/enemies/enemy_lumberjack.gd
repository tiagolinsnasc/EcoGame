extends EnemyBase

@onready var anime: AnimatedSprite2D = $anime

# -1 = esquerda, 1 = direita
@export var start_direction: int = -1

func _ready():
	# aplica a direção inicial
	direction = start_direction
	_update_detectors()  # ajusta os RayCasts para o lado inicial
	_on_direction_changed()  # atualiza flip do sprite

func play_anim(anime_name: String) -> void:
	anime.play(anime_name)

func _on_direction_changed() -> void:
	if flip_sprite:
		anime.flip_h = direction == -1

func _on_anime_animation_finished() -> void:
	on_anim_finished(anime.animation)
	
func take_damage():
	Globals.give_points_to_player(enemy_score, global_position, self)
	queue_free()
