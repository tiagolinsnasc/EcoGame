extends Area2D
var flag_on = true
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci" and flag_on:
		var img = preload("res://n_assets/n_scenes/elements/journalist_image.png")
		Globals.show_side_mensage("Uma foto! Essa mulher é uma conhecida jornalista engajada na causa ambiental.",img,10.0)		
		flag_on = false
