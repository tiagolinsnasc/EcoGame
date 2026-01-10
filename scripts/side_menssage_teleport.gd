extends Area2D
var flag_on = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci" and flag_on:
		var img = preload("uid://c0uwlw5hpsrs2")#Imagem ícone do teletransporte
		Globals.show_side_mensage("Use sua habilidade de teletransporte para vencer o obstáculo!",img,5.0)		
		flag_on = false
