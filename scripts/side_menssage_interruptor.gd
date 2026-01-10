extends Area2D
var flag_on = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci" and flag_on:
		var img = preload("uid://ca8b4p3htf8y6")
		Globals.show_side_mensage("Use o painel da sala anterior para ativar a plataforma. Seja rápida!",img,5.0)		
		flag_on = false
