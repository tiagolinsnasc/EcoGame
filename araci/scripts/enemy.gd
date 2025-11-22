extends CharacterBody2D
const SPEED = 700.0
const JUMP_VELOCITY = -400.0
var direction := -1

@onready var wall_detector := $wall_detector as RayCast2D
@onready var sprite_enemy: Sprite2D = $sprite_enemy
@onready var animation_enemy: AnimationPlayer = $animation_enemy


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1

	if direction == 1:
		sprite_enemy.flip_h = true
	else:
		sprite_enemy.flip_h = false
		
	velocity.x = direction * SPEED * delta
	
	move_and_slide()


func _on_animation_enemy_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		queue_free()
