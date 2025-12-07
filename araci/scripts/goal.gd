extends Area2D

@onready var transition: CanvasLayer = $"../transition"
@export var next_level: String = ""


func _on_body_entered(body: Node2D):
	print("Objetivo atingido!")
	if body.name == "Araci" and !next_level == "":
		transition.change_scene(next_level)
	else:
		print("Nenhum próximo estágio!")
