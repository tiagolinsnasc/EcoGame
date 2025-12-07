extends Area2D

@onready var animation_enemy: AnimatedSprite2D = $"../animation_enemy"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci":
		#print("Bateu em Araci")
		body.velocity.y = body.JUMP_VELOCITY #Pula quando mata
		animation_enemy.play("hurt")
 
