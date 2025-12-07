extends Node

var coins := 0
var score := 0
var player_life := 3

#Criados para permitir o mecanismo de checkpoint:
var araci = null #Carregado em world.gd
var current_checkpoint = null
var araci_start_position = null #Carregado em world.gd

func respaw_player():
	if current_checkpoint != null:
		araci.global_position = current_checkpoint.global_position
	else:
		araci.global_position = araci_start_position
