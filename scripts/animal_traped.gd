#Genérico, sereve para qualquer animal preso em armadilhas
extends Node2D
@export var score := 100

func _on_area_body_entered(body: Node2D) -> void:
	if body.name == "Araci":
		Globals.give_points_to_player(score,global_position,self)
		queue_free()
	if not Globals.flag_grab_one_animal_in_trap:
		Globals.show_side_mensage("Você libertou um animal de uma armadilha! Ganhou pontos!",null, 5.0)
		Globals.flag_grab_one_animal_in_trap = true
		
		
