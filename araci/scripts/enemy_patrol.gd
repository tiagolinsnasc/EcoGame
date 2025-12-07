extends CharacterBody2D

@onready var animation_enemy: AnimatedSprite2D = $animation_enemy
@export var enemy_score := 150

func _on_hitbox_body_entered(_body: Node2D):
	animation_enemy.play("hurt")

func _on_animation_enemy_animation_finished():
	if animation_enemy.animation == "hurt":
		queue_free()
		Globals.score += enemy_score
