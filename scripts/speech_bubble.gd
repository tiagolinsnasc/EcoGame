extends Node2D

@onready var label: Label = $background/Label
@onready var background: NinePatchRect = $background

func _ready():
	visible = false  # começa desativado
	
func show_message(text: String, duration: float = 2.0):
	
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	
	await get_tree().process_frame
	var text_size = label.get_minimum_size()
	background.custom_minimum_size = text_size + Vector2(20, 20)

	# Reposiciona o balão inteiro acima da cabeça
	position = Vector2(0, -background.custom_minimum_size.y - 1) 
	# "-40" é uma margem para não encostar no rosto

	#background.modulate = Color(0.5, 0.5, 0.5)
	visible = true
	await get_tree().create_timer(duration).timeout
	visible = false
