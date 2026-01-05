extends Control

@export var icon_texture: Texture2D
@export var key_text: String = ""

@onready var icon: TextureRect = $icon
@onready var key_label: Label = $key

func _ready():
	if icon_texture:
		icon.texture = icon_texture
	key_label.text = key_text

# Atualiza cor/borda conforme disponibilidade
func set_available(available: bool):
	print("set_attack_available chamado:", available)
	if available:
		# cor normal
		icon.modulate = Color(1, 1, 1)   # branco (sem alteração)
		key_label.modulate = Color(1, 1, 1)
	else:
		# cor esmaecida para indicar recarga
		icon.modulate = Color(0.5, 0.5, 0.5)   # cinza
		key_label.modulate = Color(0.7, 0.7, 0.7)
