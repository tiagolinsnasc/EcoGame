#Genérico, sereve para qualquer animal preso em armadilhas
extends Node2D
@export var score := 100



func _on_area_body_entered(body: Node2D) -> void:
	if body.name == "Araci":
		Globals.score += score
		give_points_to_player()
		queue_free()
	if not Globals.flag_grab_one_animal_in_trap:
		var hud = get_tree().root.get_node("World-02/interface/HUD/control")
		hud.show_notification("Você libertou um animal de uma armadilha! Ganhou pontos!",null, 5.0)
		Globals.flag_grab_one_animal_in_trap = true
		
#Carrega a cena score_popup que mostra a pontuação na tela
func give_points_to_player():
	#print("Chamou pontos na tela")
	var popup_scene = preload("res://prefabs/score_popup.tscn")
	var popup = popup_scene.instantiate()
	get_tree().current_scene.add_child(popup)
	popup.show_points(score, global_position + Vector2(0, -16))
