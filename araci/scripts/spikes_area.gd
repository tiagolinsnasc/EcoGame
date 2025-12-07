extends Area2D

@onready var collision: CollisionShape2D = $collision
@onready var spikes: Sprite2D = $spikes

# Called when the node enters the scene tree for the first time.
func _ready():
	collision.shape.size = spikes.get_rect().size



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci" && body.has_method("take_damage"):
		print("player nos espinhos")
		body.take_damage(Vector2(0,-250))
