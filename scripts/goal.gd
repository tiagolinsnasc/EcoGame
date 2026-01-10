extends Area2D

@export var next_level: String = ""
@onready var transition: CanvasLayer = $"../interface/transition"
@onready var anime: AnimationPlayer = $anime
@onready var end_stage_sound: AudioStreamPlayer2D = $end_stage_sound

func _ready() -> void:
	anime.play("move")

func _on_body_entered(body: Node2D):
	print("Objetivo atingido!")
	if body.name == "Araci" and !next_level == "":
		end_stage_sound.play()
		#await end_stage_sound.finished
		transition.change_scene(next_level)
	else:
		print("Nenhum próximo estágio!")
