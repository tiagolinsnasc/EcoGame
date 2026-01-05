extends Node2D
#Deve ser chamado na quando os pontos forem adicionados
@onready var label: Label = $pontos
@onready var anim: AnimationPlayer = $animation

func show_points(points: int, l_position: Vector2) -> void:
	#print("Exibiu pontos")
	# Define o texto
	label.text = "+" + str(points)
	# Define a posição inicial (acima do item)
	global_position = l_position
	# Inicia a animação
	anim.play("popup")

# Esse método será chamado pelo Call Method Track:
# No animation player - adicionar Track Call Mathod Track -> add key, e escolher o método do script
func remove_popup() -> void:
	#print("Removeu label da cena")
	queue_free()
