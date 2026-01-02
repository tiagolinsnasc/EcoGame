extends Node2D

@onready var araci: CharacterBody2D = $Araci
@onready var camera: Camera2D = $camera

@onready var araci_scene = preload("res://actors/araci.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Salva o player antes da modificações a seguir (útil para o checkpoint)
	Globals.araci = araci
	#Carrega a posição de Araci a partir de um mark 2D no início da fase, quando não tem checkpoints
	Globals.araci_start_position = $araci_start_position.global_position
	
	Globals.araci.follow_camera(camera)
	Globals.araci.player_has_died.connect(reload_game)
	#Associa Araci ao pet
	Globals.set_player(araci)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func reload_game():
	await get_tree().create_timer(1.0).timeout
	araci = araci_scene.instantiate()
	add_child(araci)
	Globals.araci = araci
	Globals.araci.follow_camera(camera)
	Globals.araci.player_has_died.connect(reload_game)
	
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3
	
	Globals.respaw_player()
	#get_tree().reload_current_scene()
	
