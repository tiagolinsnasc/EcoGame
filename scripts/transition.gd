extends CanvasLayer

@onready var color_rect: ColorRect = $color_rect

func _ready():
	show_new_scene()
	
func change_scene(path, delay = 1.5):
	var scene_transiction = get_tree().create_tween()
	scene_transiction.tween_property(color_rect,"threshold",1.0,0.5).set_delay(delay)
	await scene_transiction.finished
	assert(get_tree().change_scene_to_file(path) == OK)

func show_new_scene():
	var show_transiction = get_tree().create_tween()
	show_transiction.tween_property(color_rect,"threshold",0.0,0.5).from(1.0)
