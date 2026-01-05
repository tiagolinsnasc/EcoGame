extends Area2D
var flag_on = true
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci" and flag_on:
		var img = null
		Globals.show_side_mensage("Uma fogueira representa um risco enorme para a floresta. Ganhe pontos apagando-as.",img,5.0)		
		flag_on = false
