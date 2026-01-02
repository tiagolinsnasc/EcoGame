extends Area2D

var is_active = false
@onready var anime: AnimatedSprite2D = $anime
@onready var position_checkpoint: Marker2D = $position_checkpoint

#Imagem da arvore
var tree_image := preload("res://n_assets/n_scenes/elements/checkPointIcon.png")

func _on_body_entered(body: Node2D):
	if body.name != "Araci" or is_active:
		return
	activate_checkpoit()
	
	if !Globals.flag_grab_one_checkpoint and is_instance_valid(Globals.hud):
		Globals.hud.show_notification("Você chegou a um checkpoint!",tree_image,5.0)
		Globals.flag_grab_one_checkpoint = true

func activate_checkpoit():
	print("Araci entrou")
	Globals.current_checkpoint = position_checkpoint
	anime.play("rising")
	is_active = true


func _on_anime_animation_finished():
	if anime.animation == "rising":
		anime.play("checked")
