extends Area2D

@export var next_level: String = ""
@onready var transition: CanvasLayer = $"../interface/transition"


func _on_body_entered(body: Node2D):
	print("Objetivo atingido!")
	if body.name == "Araci" and !next_level == "":
		transition.change_scene(next_level)
	else:
		print("Nenhum próximo estágio!")
