extends Area2D

@onready var animation: AnimatedSprite2D = $"../animation"
@onready var anime: AnimationPlayer = $"../../anime"


func _on_body_entered(body: Node2D) -> void:
	#print("Araci bateu no caçador!")
	if body.name == "Araci":
		body.velocity.y = body.JUMP_VELOCITY #Pula quando mata
		owner.queue_free() 
		
		
		
