extends Area2D


func _on_body_entered(body: Node2D) -> void:
	#print("Caiu....")
	if body.name == "Araci":
		body.handle_death_zone()
