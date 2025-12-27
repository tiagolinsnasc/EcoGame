extends Node
#Equivalente a evidência
var coins := 0
var score := 0
var player_life := 3

#Flags que auxiliam na exibição das primeira informações sobre os ítens coletados
var flag_grab_one_life = false
var flag_grab_one_evidence = false
var flag_grab_one_checkpoint = false
var flag_grab_one_information = false
var flag_grab_one_animal_in_trap = false

#Controle de powerups
var flag_pw_feroz_enable = false
var flag_pw_superjump = true

#Criados para permitir o mecanismo de checkpoint:
var araci = null #Carregado
var current_checkpoint = null
var araci_start_position = null #Carregado
var pet = null

func respaw_player():
	if is_instance_valid(araci):
		if current_checkpoint != null and is_instance_valid(current_checkpoint):
			# Player volta para o último checkpoint válido
			araci.global_position = current_checkpoint.global_position
		else:
			# Se não há checkpoint, volta para posição inicial
			araci.global_position = araci_start_position
	else:
		print("Araci não está válido, não foi possível reposicionar.")
	 # Atualiza o pet para seguir o novo player
	if is_instance_valid(pet):
		set_player(araci)
		
##Adiciona pontos para o player
func add_score(sc):
	score += sc

#Mecanismo para contar o tempo entre ataques do pet (Feroz)
var hud: Node = null
func update_pet_icon(available: bool):
	if hud and hud.has_method("update_pet_icon"):
		hud.update_pet_icon(available)
	else:
		print("HUD não registrado ou método ausente. available=", available)

##Carrega a cena score_popup que mostra a pontuação na tela (Já adiciona os pontos. Ex.Globals.give_points_to_player(enemy_score,global_position,self)
func give_points_to_player(i_score: int, position: Vector2, parent: Node):
	add_score(i_score)
	var popup_scene = preload("res://prefabs/score_popup.tscn")
	var popup = popup_scene.instantiate()
	parent.get_tree().current_scene.add_child(popup)
	popup.show_points(i_score, position + Vector2(0, -16))

##Utiliza a show notification do HUD (área no canto inferior direito para exibir uma mensagem), tamnho adequado da imagem
func show_side_mensage(mensage: String,image,time: float = 5.0):
	if hud and hud.has_method("show_notification"):
		hud.show_notification(mensage, image, time)
	else:
		print("HUD não disponível para mostrar mensagem:", mensage)

##Atualiza o estado do HUD com o valor na variável flag de Globals, deve chamar sempre que as variáveis flags do pet for alterada
func update_pet_visibility():
	if hud and hud.has_node("container/powerups_container/powerupIcon"):
		#print("Atualizou a visibilidade:",flag_pw_feroz_enable)
		var pet_icon = hud.get_node("container/powerups_container/powerupIcon")
		pet_icon.visible = flag_pw_feroz_enable
		
##Ativa o poweup Feroz 
func pw_feroz_enabled():
	flag_pw_feroz_enable = true
	update_pet_visibility()

##Desativa o poweup Feroz 
func pw_feroz_disabled():
	flag_pw_feroz_enable = false
	update_pet_visibility()

##Adiciona Araci como instância atual, associa ao Feroz automaticamente
func set_player(new_player: Node):
	if is_instance_valid(new_player):
		araci = new_player
		# Atualiza o pet para seguir o novo player
		if is_instance_valid(pet):
			pet.player = araci
