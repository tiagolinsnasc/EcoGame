extends Control
var cards = [
	preload("res://n_assets/n_cuts/final/s1.png"),
	preload("res://n_assets/n_cuts/final/s2.png"),
	preload("res://n_assets/n_cuts/final/s3.png"),
	preload("res://n_assets/n_cuts/final/s4.png"),
	preload("res://n_assets/n_cuts/final/s5.png"),
	preload("res://n_assets/n_cuts/final/s6.png"),
	preload("res://n_assets/n_cuts/final/s7.png")
]

var current_index = 0

func _ready():
	show_card(current_index)

func show_card(index):
	$TextureRect.texture = cards[index]
	$ColorRect.modulate.a = 1.0
	$AnimationPlayer.play("fade_in")

func _input(event):
	if event.is_action_pressed("ui_accept"): # espaço
		if current_index < cards.size() - 1:
			current_index += 1
			show_card(current_index)
		else:
			queue_free() # ou mude para outra cena
	elif event.is_action_pressed("ui_cancel"): # ESC
		queue_free() # encerra a exibição
