extends Control

@onready var coins_counter: Label = $container/coins_conteiner/coins_counter
@onready var score_counter: Label = $container/score_container/score_counter
@onready var time_label: Label = $container/time_container/time_label
@onready var life_counter: Label = $container/life_conteiner/life_counter


func _ready():
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	
func _process(_delta: float):
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)

@onready var notification_box = $notification_box
@onready var notif_label = $notification_box/NinePatchRect/HBoxContainer/Label
@onready var notif_icon = $notification_box/NinePatchRect/HBoxContainer/TextureRect

var is_showing := false
var queue := []  # fila de mensagens

func show_notification(text: String, image: Texture2D = null, duration := 2.0):
	
	#Hifenização para PT_BR via script em Global.gd (não funcionou, embaralhor o texto)
	#var largura_maxima = notif_label.size.x
	#var texto_formatado = Globals.hyphenate_text_ptbr(text, largura_maxima, notif_label)
	#text = texto_formatado
	
	# Se já tem uma notificação ativa, coloca na fila
	if is_showing:
		queue.append([text, image, duration])
		return

	is_showing = true

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
