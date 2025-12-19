extends Area2D


func _on_body_entered(body: Node2D) -> void:
	#print("Araci bateu no caçador!")
	if body.name == "Araci":
		body.velocity.y = body.jump_velocity #Pula quando mata
		owner.queue_free() 
		
		
		
