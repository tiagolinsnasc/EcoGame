extends Area2D

#Script do hitbox - causar dano no player
func _on_body_entered(body: Node2D) -> void:
		if body.name == "Araci" && body.has_method("take_damage"):
			print("Sofreu dano do caçador!")
			#morre de uma vez e vai para o início ou último checkpoint
			#body.handle_death_zone()
			body.take_damage(Vector2(0,-250))
			
			#owner.queue_free() 
		
		
		
