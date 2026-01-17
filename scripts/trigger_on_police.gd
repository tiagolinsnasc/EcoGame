extends Area2D

@onready var animator_police: AnimationPlayer = $"../animator_police"

func _on_body_entered(body: Node2D) -> void:
	animator_police.play("arrest")
