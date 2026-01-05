extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#Imagem da porção azul
var poison_image := preload("res://n_assets/n_scenes/elements/blue_poison_icon.png")

func _on_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	#print("Araci coletou!")
	$amination_life.play("collect")
	await $CollisionShape2D.call_deferred("queue_free") #Espera a colisão acabar (impede que o item seja coletado duas vezes)
	Globals.show_side_mensage("Você ganhou o poder do superpulo! Pressione W enquanto pula.",poison_image,8.0)
	Globals.pw_superjump_enabled()
	Globals.araci.play_upgrade()

	
func _on_amination_life_animation_finished() -> void:
	queue_free()
