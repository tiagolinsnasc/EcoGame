extends Area2D

var bullet_speed := 300
var direction := Vector2.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	position += bullet_speed * delta * direction


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
	
var knockback_vector := Vector2.ZERO
var knockback_power := 2

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci":
		#Não pula, knockback_power := 0 e -1, só fica vermelha
		var knockback = Vector2((global_position.x - body.global_position.x)*knockback_power,-1)
		body.take_damage(knockback) 
		queue_free()
