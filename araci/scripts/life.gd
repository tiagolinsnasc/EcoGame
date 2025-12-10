extends Area2D

var life := 1 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	#print("Araci coletou!")
	$amination_life.play("collect")
	await $CollisionShape2D.call_deferred("queue_free") #Espera a colisão acabar (impede que uma coin seja coletada duas vezes)
	Globals.player_life += life
	#print("Coletou vida")

func _on_amination_life_animation_finished() -> void:
	queue_free()
