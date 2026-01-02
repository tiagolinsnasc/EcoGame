extends Node2D

@onready var texture: Sprite2D = $texture
@onready var area_sign: Area2D = $area_sign

const lines: Array[String] = [
	"Olá aventureira",
	"É bom vê-lo por aqui",
	"Siga em frente",
	"Já que você é professora...",
	"Seja forte e corajosa!",
]

func _unhandled_input(event: InputEvent):
	#Se os corpos são sobrepostos
	if area_sign.get_overlapping_bodies().size() > 0:
		print("Entrou em contato com a placa!")
		
		texture.show()
		if event.is_action_pressed("interact") && !DialogManager.is_message_active:
			print("Pressionou I, para interagir")
			texture.hide()
			DialogManager.start_message(global_position, lines)
		else:
			texture.hide()
			if DialogManager.dialog_box != null:
				DialogManager.dialog_box.queue_free()
				DialogManager.is_message_active = false
