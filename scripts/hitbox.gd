extends Area2D

#O modelo de ataque é qualquer contato, se for pulo na parte superior (ajustar o hitbox)
#O finciona para silgle enemy. Se o enimigo estiver dentro de um nó 2d owner.animation_enemy não funciona
func _on_body_entered(body: Node2D) -> void:
	#print("Colidiu com:")
	if body.name == "Araci":
		body.velocity.y = body.JUMP_VELOCITY #Pula quando mata
		#owner.animation_enemy.play("hurt") #Dá erro poque considerar pegar as informações no no 2D em vez de ser em enemy_protrol (CharacterBody2d)
		owner.animation_enemy.play("hurt")
		#print(body.name )
