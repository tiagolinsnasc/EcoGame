extends Area2D

@onready var collision: CollisionShape2D = $collision

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#Cuidado aqui o dano está associado ao body do player e não à hurtbox
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci" && body.has_method("take_damage"):
		print("Na área de dano")
		#morre de uma vez e vai para o início ou último checkpoint
		#body.handle_death_zone()
		body.take_damage(Vector2(0,-250))
