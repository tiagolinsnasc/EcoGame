extends Control

@onready var coins_counter: Label = $container/coins_conteiner/coins_counter
@onready var score_counter: Label = $container/score_container/score_counter
@onready var life_counter: Label = $container/life_conteiner/life_counter
@onready var ambient_sound: AudioStreamPlayer = $"../../ambient_sound"
  

func _ready():
	coins_counter.text = str("%02d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	#Passa o hud para o Globals para controle dos cooldowns
	Globals.hud = self
	Globals.update_pet_visibility()
	Globals.update_super_jump_visibility()
	Globals.update_teleport_visibility()
	Globals.ambient_player = ambient_sound
	
#Icones variáveis do estado dos poweups
var pw_sj_icon_l1 = preload("res://n_assets/n_scenes/elements/superjump_icon_l1.png")
var pw_sj_icon_l2 = preload("res://n_assets/n_scenes/elements/superjump_icon_l2.png")
var pw_sj_icon_l3 = preload("res://n_assets/n_scenes/elements/superjump_icon_l3.png")

var pw_tp_icon_l1 = preload("res://n_assets/n_scenes/elements/teleport_icon_l1.png")
var pw_tp_icon_l2 = preload("res://n_assets/n_scenes/elements/teleport_icon_l2.png")
var pw_tp_icon_l3 = preload("res://n_assets/n_scenes/elements/teleport_icon_l3.png")

#Flag para exibir mensagens de evolução de powerups
var flag_pw_sj_l2 = false;
var flag_pw_sj_l3 = false;

var flag_pw_tp_l2 = false;
var flag_pw_tp_l3 = false;

func _process(_delta: float):
	coins_counter.text = str("%02d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	
	#Cuida da dinâmica de mostrar na tela os íncones com a evolução dos superpoderes
	#superjump_level e teleport_level já alteram o fator de multiplicação do superpulo e teleport
	var v_superjump_level = Globals.superjump_level();
	#print("Nivel do superpulo: "+str(v_superjump_level))
	if v_superjump_level == 1:
		super_jump.icon.texture = pw_sj_icon_l1
	elif v_superjump_level == 2:
		if not flag_pw_sj_l2:#Mensagem do aumento
			Globals.show_side_mensage("A altura do super pulo aumentou em 10%!",pw_sj_icon_l2,5.0)
			flag_pw_sj_l2 = true	
		super_jump.icon.texture = pw_sj_icon_l2
	elif v_superjump_level == 3:
		if not flag_pw_sj_l3:#Mensagem do aumento
			Globals.show_side_mensage("A altura do super pulo aumentou em 30%!",pw_sj_icon_l3,5.0)
			flag_pw_sj_l3 = true
		super_jump.icon.texture = pw_sj_icon_l3
		
	if Globals.teleport_level() == 1:
		teleport.icon.texture = pw_tp_icon_l1
	elif Globals.teleport_level() == 2:
		if not flag_pw_tp_l2:#Mensagem do aumento
			Globals.show_side_mensage("Distância de teletransporte aumentou em 10%!",pw_tp_icon_l2,5.0)
			flag_pw_tp_l2 = true	
		teleport.icon.texture = pw_tp_icon_l2
	elif Globals.teleport_level() == 3:
		if not flag_pw_tp_l3:#Mensagem do aumento
			Globals.show_side_mensage("Distância de teletransporte aumentou em 30%!",pw_tp_icon_l3,5.0)
			flag_pw_tp_l3 = true	
		teleport.icon.texture = pw_tp_icon_l2
		teleport.icon.texture = pw_tp_icon_l3

@onready var notification_box = $notification_box
@onready var notif_label = $notification_box/NinePatchRect/HBoxContainer/Label
@onready var notif_icon = $notification_box/NinePatchRect/HBoxContainer/TextureRect
@onready var audio_msg: AudioStreamPlayer = $"../../msg_audio"

#Som da mensagem

var is_showing := false
var queue := []  # fila de mensagens

func show_notification(text: String, image: Texture2D = null, duration := 2.0):
	
	# Se já tem uma notificação ativa, coloca na fila
	if is_showing:
		queue.append([text, image, duration])
		return

	is_showing = true
	
	#Toca o audio - Usado o AudioStreamPlayer (em mensagens do HUD) é adequado porque não têm relevância espacial dentro da cena, por isso não precisa de position
	audio_msg.play()
	
	
	# Preenche conteúdo
	notif_label.text = text

	if image != null:
		notif_icon.texture = image
		notif_icon.show()
	else:
		notif_icon.hide()

	# Mostra
	notification_box.modulate.a = 1.0
	notification_box.show()

	# Espera X segundos
	await get_tree().create_timer(duration).timeout

	# Fade-out
	var tween = get_tree().create_tween()
	tween.tween_property(notification_box, "modulate:a", 0.0, 0.4)
	await tween.finished

	notification_box.hide()
	is_showing = false

	# Se houver mensagens na fila, mostra a próxima
	if queue.size() > 0:
		var next = queue.pop_front()
		show_notification(next[0], next[1], next[2])


#mecanismo de exibição de icones correspondente aos power ups disponíveis
@onready var powerups_box = $container/powerups_container
@onready var pet = $container/powerups_container/powerupIcon
@onready var super_jump = $container/powerups_container/powerupIcon2
@onready var teleport = $container/powerups_container/powerupIcon3

func add_powerup(texture: Texture2D, key: String):
	var icon_scene = preload("res://prefabs/powerup_icon.tscn")
	var icon_instance = icon_scene.instantiate()
	icon_instance.setup(texture, key)
	powerups_box.add_child(icon_instance)

##Permite deixar o icone desabilitado
func update_pet_icon(available: bool):
	pet.set_available(available)
	#print("PetIcon existe? ", $container/powerups_container/powerupIcon)
	
##Permite deixar o icone do superpulo desabilitado
func update_superjump(available: bool):
	super_jump.set_attack_available(available)
	#print("PetIcon existe? ", $container/powerups_container/powerupIcon)
	
##Permite deixar o icone do teletransporte desabilitado
func update_teleport(available: bool):
	teleport.set_attack_available(available)
	#print("PetIcon existe? ", $container/powerups_container/powerupIcon)
