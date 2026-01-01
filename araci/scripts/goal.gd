extends Area2D

@export var next_level: String = ""
@onready var transition: CanvasLayer = $"../interface/transition"
@onready var anime: AnimationPlayer = $anime

func _ready() -> void:
	anime.play("move")

func _on_body_entered(body: Node2D):
	print("Objetivo atingido!")
	if body.name == "Araci" and !next_level == "":
		transition.change_scene(next_level)
	else:
		print("Nenhum próximo estágio!")
