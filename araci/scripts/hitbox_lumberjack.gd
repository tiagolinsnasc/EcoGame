extends Area2D

#Atenção: inimigos com o anime implementado em AnimatedSprite 
#deve ter as animação acessadas através do AnimatedSprinte, AnimationPlayer não tem função aqui
#Usando o AnimatedSprinte também não foi possível reaproveitar o hitbox (criado originalmente para enemy)
#Importante: na aula - Ep09 - Causando e Sofrendo Danos (Hitbox e Hurtbox) na GODOT 4.0 - Criando um Jogo de Plataforma 2D
#a câmera foi separada do player

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci":
		#print("Bateu em Araci")
		body.velocity.y = body.JUMP_VELOCITY #Pula quando mata
		owner.stop()
		owner.texture.play("hurt")
