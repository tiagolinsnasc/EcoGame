extends Area2D


@onready var animator: AnimationPlayer = $"../animator_report"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Araci":
		print("Player na área de reportagem!")
		body.paralyze_player()
		animator.play("report")
		
