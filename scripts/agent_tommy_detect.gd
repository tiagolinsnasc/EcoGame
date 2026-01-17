extends Area2D
@onready var speech_bubble: Node2D = $"../speech_bubble"
var flag_said = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci" and not flag_said:
		speech_bubble.show_message("Bom trabalho, Araci. Há muito tempo investigamos a quadrilha e agora chegamos ao chefe!",8.0)
		flag_said = true
