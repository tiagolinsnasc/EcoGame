extends Node2D
#Script simples, apenas para permitir a escolha da animação no nó do estágio
@export var idle = true
@onready var anime: AnimatedSprite2D = $crow/anime
@onready var animation: AnimationPlayer = $animation
@export var animal_name = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if idle:
		anime.play("idle")
	else:
		anime.play("fly")
		animation.play("fly_route")
