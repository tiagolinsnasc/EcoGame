extends Area2D


#Imagem do caburé
var information_image := preload("res://n_assets/n_scenes/elements/cabureIcon.png")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci":
		if !Globals.flag_grab_one_information and is_instance_valid(Globals.hud):
			Globals.hud.show_notification(
				"O caburé trará informações relevantes para a sua jornada!",
				information_image,
				5.0
			)
			Globals.flag_grab_one_information = true
		
