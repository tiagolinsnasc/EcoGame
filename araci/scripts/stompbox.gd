extends Area2D

##Não interfere no Player, só chama a função stomped() no inimigo. O inimigo decide o que fazer (morrer, animar, etc.)
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("stomped"):
		body.stomped()
 
