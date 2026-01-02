extends Node2D

var active_fire := true

func _on_fire_area_area_entered(area: Area2D) -> void:
	print("Contato com o fogo!", area.name)
	if area.name == "hurtbox" and active_fire: #hutbox é o nome do nó que recebe danos em Araci
		print("Araci no fogo!")
		$anime.play("action")
		var player = area.get_parent()  # sobe um nível para pegar o CharacterBody2D
		if player.has_method("take_damage"):
			var direction_jump:float = sign(player.global_position.x - area.global_position.x)
			var knockback:Vector2 = Vector2(600 * direction_jump, -350)
			player.take_damage(knockback)
