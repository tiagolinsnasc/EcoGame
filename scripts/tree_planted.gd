extends Area2D

var is_tree= false
@onready var anime: AnimatedSprite2D = $anime
@onready var position_checkpoint: Marker2D = $position_checkpoint
@export var score = 100

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Araci" or is_tree:
		return
	grow()

func _on_anime_animation_finished() -> void:
	if anime.animation == "rising":
		anime.play("idlle")

var imagem_locus_eliminated = preload("res://n_assets/n_scenes/elements/locust_banish.png")
var imagem_embauba_planted = preload("res://n_assets/n_scenes/elements/tree_planted_icon.png")

@onready var hided_birds: Node2D = $"../../hided_birds"

##Ativa o nó hided_birds, mostra as aves já previamente localizadas, mas escondidadas pela propriedade do nó
func call_birds() -> void:
	#Lembrar de começar com os pássaros invisíveis, isso não desabilita a colisão, então cuidado quando fizer isso com inimigos
	hided_birds.visible = true

func grow():
	print("Araci plantou a árvore!")
	Globals.give_points_to_player(score,global_position,self)
	anime.play("rising")
	is_tree = true
	Globals.count_planted_trees_w3 += 1
	var restante = Globals.max_planted_trees_w3 - Globals.count_planted_trees_w3
	
	if Globals.count_planted_trees_w3 < Globals.max_planted_trees_w3:
		Globals.show_side_mensage("Embaúba plantada! Faltam " + str(restante), imagem_embauba_planted, 3.0)
	else:
		Globals.show_side_mensage("Você já plantou árvores suficientes. Os pássaros já conseguem controlar a praga de gafanhotos!", imagem_locus_eliminated, 9.0)
		call_birds()
