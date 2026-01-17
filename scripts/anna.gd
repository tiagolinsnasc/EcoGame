extends CharacterBody2D

@onready var anime: AnimatedSprite2D = $anime
@onready var speech_bubble: Node2D = $speech_bubble

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	#anime.play("idle")
	pass

func _physics_process(delta: float) -> void:
	speech_bubble.scale.x = self.scale.x * -1
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
func say(text: String, time: float):
	speech_bubble.show_message(text, time)
	
	
