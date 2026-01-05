extends PeacefulAnimalsBase

#Aumenta ou diminui a velocidade quando detecta o player
func _on_detect_body_entered(body: Node2D) -> void:
	if body.name == "Araci":
		SPEED = 5000
		

func _on_detect_body_exited(body: Node2D) -> void:
	if body.name == "Araci":
		SPEED = 1100
