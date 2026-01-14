extends Node2D

@onready var anime: AnimatedSprite2D = $anime
@onready var damage_area: Area2D = $damage_area
@onready var detect_area: Area2D = $detect_area
@onready var cooldown_timer: Timer = $attack_timer
@onready var explosion: AudioStreamPlayer2D = $explosion

@export var attack_interval := 5.0
@export var max_attack_distance := 900.0
@export var is_independet = false
@onready var origin_position: Vector2 = global_position

#var origin_position: Vector2
var target: Node2D = null
var speed: float = 120.0

var is_attacking_cycle: bool = false
var is_dying: bool = false

func flying():
	if is_independet:
		anime.play("fly_on_independent")
	else:
		anime.play("fly_controlled")

func idle():
	if is_independet:
		anime.play("idle_on_independent")
	else:
		anime.play("idle_on_controlled")

func _ready():
	is_dying = false
	is_attacking_cycle = false
	target = null

	origin_position = global_position

	cooldown_timer.wait_time = attack_interval
	cooldown_timer.one_shot = true
	cooldown_timer.stop()
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	idle()

func _on_detect_area_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox" and not is_attacking_cycle and not is_dying:
		target = area.get_parent()
		if target:
			_start_attack_cycle()

func _on_detect_area_area_exited(area: Area2D) -> void:
	if area.name == "hurtbox" and not is_dying:
		target = null
		cooldown_timer.stop()
		is_attacking_cycle = false
		damage_area.monitoring = false
		await _return_to_origin()

func die():
	if is_dying: return
	is_dying = true
	damage_area.monitoring = false
	detect_area.monitoring = false
	is_attacking_cycle = false
	target = null
	anime.play("fall")
	print("Drone deve morrer!")

func _physics_process(delta: float) -> void:
	if is_dying:
		global_position.y += 10 * delta
		anime.play("explosion")
		explosion.play()
		if not anime.animation_finished.is_connected(_on_explosion_finished):
			anime.animation_finished.connect(_on_explosion_finished)
		return

	if is_attacking_cycle and target:
		if global_position.distance_to(target.global_position) > max_attack_distance:
			is_attacking_cycle = false
			damage_area.monitoring = false
			cooldown_timer.stop()
			await _return_to_origin()
			return
		global_position = global_position.move_toward(target.global_position, speed * delta)

func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox" and is_attacking_cycle and not is_dying:
		var player = area.get_parent()
		if player.has_method("take_damage"):
			var direction_jump: float = sign(player.global_position.x - global_position.x)
			var knockback: Vector2 = Vector2(600 * direction_jump, -350)
			player.take_damage(knockback)
			anime.play("shake")
			await anime.animation_finished

		is_attacking_cycle = false
		damage_area.monitoring = false
		await _return_to_origin()

		if target:
			cooldown_timer.start()
		
		flying()

func _on_cooldown_timeout() -> void:
	if target and not is_attacking_cycle and not is_dying:
		_start_attack_cycle()

func _start_attack_cycle() -> void:
	if not target or is_dying: return
	is_attacking_cycle = true
	damage_area.monitoring = true
	flying()

func _return_to_origin() -> void:
	if is_dying: return
	var tween = create_tween()
	tween.tween_property(self, "global_position", origin_position, 1.5)
	await tween.finished
	idle()

func _on_explosion_finished():
	queue_free()
