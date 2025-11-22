extends Area2D

#O modelo de ataque é qualquer contato, se for pulo na parte superior (ajustar o hitbox)
func _on_body_entered(body: Node2D) -> void:
	print("Colidiu com:")
	if body.name == "Araci":
		body.velocity.y = body.JUMP_VELOCITY #Pula quando mata
		owner.animation_enemy.play("hurt")
		#print(body.name)
