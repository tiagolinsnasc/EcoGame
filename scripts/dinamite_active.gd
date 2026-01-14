extends CharacterBody2D

@onready var anime: AnimatedSprite2D = $anime
@onready var damage_area: Area2D = $damage_area
@onready var activation_area: Area2D = $activation_area

@onready var wick_fire_sound: AudioStreamPlayer2D = $wick_fire_sound
@onready var explosion_sound: AudioStreamPlayer2D = $explosion_sound
@export var explosion_timer = 2.0

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func detone():
	await get_tree().create_timer(explosion_timer).timeout
	anime.stop()
	anime.play("explosion")
	explosion_sound.play()
	damage_area.monitoring = true

func _on_activation_area_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		print("Ativou dinamite")
		wick_fire_sound.play()
		anime.play("action")
		activation_area.set_deferred("monitoring", false)
		detone()

func _on_anime_animation_finished() -> void:
	if anime.animation == "explosion":
		wick_fire_sound.stop()
		damage_area.monitoring = false
		await get_tree().create_timer(explosion_sound.stream.get_length()).timeout
		queue_free()

func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		print("Está na área de dano!")
		var player = area.get_parent()
		if player.has_method("take_damage"):
			var direction_jump: float = sign(player.global_position.x - global_position.x)
			var knockback: Vector2 = Vector2(600 * direction_jump, -500)
			player.take_damage(knockback)
