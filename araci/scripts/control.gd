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
