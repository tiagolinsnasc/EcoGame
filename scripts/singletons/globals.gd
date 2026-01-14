extends Node
#Equivalente a evidência
var coins := 0
var score := 0
var player_life := 3

#Flags que auxiliam na exibição das primeira informações sobre os ítens coletados/gatilhos
var flag_grab_one_life = false
var flag_grab_one_evidence = false
var flag_grab_one_checkpoint = false
var flag_grab_one_information = false
var flag_grab_one_animal_in_trap = false
var flag_stay_on_sand = false

#Indica que já existe uma mensagem ativa na tela (serve para informações dos inimigos)
var flag_message_active = false 

#Controle de powerups
var flag_pw_feroz_enable = true
var flag_pw_superjump = true
var flag_pw_teletransport = true

#Criados para permitir o mecanismo de checkpoint:
var araci = null #Carregado
var current_checkpoint = null
var araci_start_position = null #Carregado
var pet = null

#Contadores para o estágio 3 - mecânica de plantar árvores
var count_planted_trees_w3 = 0
var max_planted_trees_w3 = 5

##Retorna true se a quantidade de árvores plantadas for maior ou igual ao mínimo necessário para eliminar os gafanhotos
func eliminate_locust():
	return count_planted_trees_w3 >= max_planted_trees_w3


#####Sons dos estgios
var stage_sounds = {
	1: preload("res://sounds/system/forest_song_e1.ogg"),
	2: preload("res://sounds/system/forest_song_e1.ogg"),
	3: preload("res://sounds/system/wind_e3.ogg"),
	4: preload("res://sounds/system/caatinga_song.ogg"),
	5: preload("res://sounds/system/caatinga_song.ogg"),
	6: preload("res://sounds/system/city_sound.ogg"),
}
var current_stage: int = 1

func respaw_player():
	#if is_instance_valid(araci):
		#if current_checkpoint != null and is_instance_valid(current_checkpoint):
			## Player volta para o último checkpoint válido
			#araci.global_position = current_checkpoint.global_position
		#else:
			## Se não há checkpoint, volta para posição inicial
			#araci.global_position = araci_start_position
	#else:
		#print("Araci não está válido, não foi possível reposicionar.")
	 ## Atualiza o pet para seguir o novo player
	#if is_instance_valid(pet):
		#set_player(araci)
		
	if not is_instance_valid(araci):
		print("Araci não está válido, recrie o player antes de respawnar.")
		return

	var target_pos = araci_start_position
	if current_checkpoint != null and is_instance_valid(current_checkpoint):
		target_pos = current_checkpoint.global_position

	araci.global_position = target_pos

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
	
	#Toca o som de pontos ganhos (Correrá para qualquer evento que gere pontuação)
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = preload("res://sounds/coletables/points_gained.ogg")
	get_tree().current_scene.add_child(audio_player) # nó persistente
	audio_player.position = position
	audio_player.play()
	
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

#------------- FEROZ POWERUP (PET) ------------------------

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

##Atualiza o estado do HUD com o valor na variável flag de Globals, deve chamar sempre que as variáveis flags do pet for alterada
func update_pet_visibility():
	if hud and hud.has_node("container/powerups_container/powerupIcon"):
		#print("Atualizou a visibilidade:",flag_pw_feroz_enable)
		var pet_icon = hud.get_node("container/powerups_container/powerupIcon")
		pet_icon.visible = flag_pw_feroz_enable

#------------- SUPERJUMP POWERUP ------------------------
##Ativa o poweup Superjump 
func pw_superjump_enabled():
	flag_pw_superjump = true
	update_super_jump_visibility()

##Desativa o poweup Superjump 
func pw_superjump_disabled():
	flag_pw_superjump = false
	update_super_jump_visibility()

##Verifica se o superpulo está disponível (se já foi habilitado para uso)
func can_super_jump() -> bool: 
	return flag_pw_superjump
	
##Atualiza o estado do HUD com o valor na variável flag de Globals, deve chamar sempre que as variáveis flags do pet for alterada
func update_super_jump_visibility():
	if hud and hud.has_node("container/powerups_container/powerupIcon2"):
		#print("Atualizou a visibilidade:",flag_pw_feroz_enable)
		var sj_icon = hud.get_node("container/powerups_container/powerupIcon2")
		sj_icon.visible = flag_pw_superjump

#------------- TELEPORT POWERUP ------------------------
##Verifica se o teletransporte está disponível (se já foi habilitado para uso)
func can_teleport() -> bool: 
	return flag_pw_teletransport
	
##Ativa o poweup Superjump 
func pw_teleport_enabled():
	flag_pw_teletransport = true
	update_teleport_visibility()

##Desativa o poweup Superjump 
func pw_teleport_disabled():
	flag_pw_teletransport = false
	update_teleport_visibility()

##Atualiza o estado do HUD com o valor na variável flag de Globals, deve chamar sempre que as variáveis flags do pet for alterada
func update_teleport_visibility():
	if hud and hud.has_node("container/powerups_container/powerupIcon3"):
		#print("Atualizou a visibilidade:",flag_pw_feroz_enable)
		var teleport_icon = hud.get_node("container/powerups_container/powerupIcon3")
		teleport_icon.visible = flag_pw_teletransport

### Som ambiente
var ambient_player: AudioStreamPlayer = null

func play_ambient(stream_or_path):
	if ambient_player == null:
		ambient_player = AudioStreamPlayer.new()
		add_child(ambient_player)

	# Aceita tanto String quanto AudioStream
	if typeof(stream_or_path) == TYPE_STRING:
		ambient_player.stream = load(stream_or_path) as AudioStream
	elif stream_or_path is AudioStream:
		ambient_player.stream = stream_or_path
	else:
		push_error("play_ambient recebeu tipo inválido: %s" % typeof(stream_or_path))
		return

	# Ajuste de volume (mais baixo)
	ambient_player.volume_db = -10   # por exemplo, -10 dB deixa mais suave

	# Loop ativado
	ambient_player.stream.loop = true

	ambient_player.play()

#Religar som ambiente
#var ambient_stream = Globals.stage_sounds.get(stage_number, null)
 #if ambient_stream:
 #Globals.play_ambient(ambient_stream)
##Para o som ambiente (útil em cavernas)
func stop_ambient_sound():
	if ambient_player and ambient_player.playing:
		ambient_player.stop()

##Verifica se o som ambiente está tocando
func is_ambient_playing() -> bool:
	return ambient_player != null and ambient_player.playing
