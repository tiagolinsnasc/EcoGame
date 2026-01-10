extends Area2D
#Apaga a fogueira
@onready var anime: AnimatedSprite2D = $"../anime"
var on = true
@export var score := 100
@onready var fire_sound: AudioStreamPlayer2D = $fire_sound


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci" and on:
		#print("Araci apagou o fogo!")
		Globals.give_points_to_player(score,global_position,self)
		anime.play("off")
		fire_sound.stop()
		on = false
