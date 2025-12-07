extends Area2D

@onready var animation: AnimatedSprite2D = $"../animation"
@onready var anime: AnimationPlayer = $"../../anime"

func _on_body_entered(body: Node2D) -> void:
	#print("Colidiu com:")
	if body.name == "Araci":
		body.velocity.y = body.JUMP_VELOCITY #Pula quando mata
		anime.pause() #Pausa a nimação do AnimationPlay, evita que o enemy se mova na execução do hurt
		animation.play("hurt")
	
