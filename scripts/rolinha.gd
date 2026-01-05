extends Node2D

@onready var animator: AnimationPlayer = $animator
@onready var anime: AnimatedSprite2D = $rolinha/anime

func _on_on_fly_body_entered(body: Node2D) -> void:
	if body.name == "Araci":
		anime.play("fly")
		animator.play("fly_out")


func _on_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fly_out":
		queue_free()
