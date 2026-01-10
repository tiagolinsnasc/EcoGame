extends Node2D
@export var item_name = ""
@export var item_description = ""
@export var show_time = 5.0
@export var enemy_icon: Texture2D


func _on_area_info_body_entered(body: Node2D) -> void:
	if body.name == "Araci":
		Globals.show_side_mensage(item_description,enemy_icon,show_time)
