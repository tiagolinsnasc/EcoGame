extends Area2D

var is_active = false
@onready var anime: AnimatedSprite2D = $anime
@onready var position_checkpoint: Marker2D = $position_checkpoint


func _on_body_entered(body: Node2D):
	if body.name != "Araci" or is_active:
		return
	activate_checkpoit()

func activate_checkpoit():
	print("Araci entrou")
	Globals.current_checkpoint = position_checkpoint
	anime.play("rising")
	is_active = true


func _on_anime_animation_finished():
	if anime.animation == "rising":
		anime.play("checked")
