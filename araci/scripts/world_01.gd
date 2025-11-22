extends Node2D

@onready var araci: CharacterBody2D = $Araci
@onready var camera: Camera2D = $camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	araci.follow_camera(camera)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
