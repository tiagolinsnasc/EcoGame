extends Area2D

#Dano ao pular na cabeça do inimigo
func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.name == "stompbox":
		print("Ganhou pontos:"+ str(get_parent().enemy_score))
		
		var player := area.get_parent()
		player.velocity.y = player.jump_velocity
		
		Globals.give_points_to_player(get_parent().enemy_score,get_parent().global_position,get_parent())
		get_parent().queue_free()
