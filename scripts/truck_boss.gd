extends CharacterBody2D
@onready var detect_player: Area2D = $detect_player
@onready var anime: AnimatedSprite2D = $anime
@onready var animation: AnimationPlayer = $animation

var started = false

func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.name == "Araci" and not started:
		anime.play("move")
		animation.play("move")


func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.name == "Araci" and started:
		anime.stop()
		animation.pause()
