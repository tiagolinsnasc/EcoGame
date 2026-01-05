extends CanvasLayer

@onready var resume_btn: Button = $menu_holder/resume_btn

func _ready() -> void:
	visible = false
	resume_btn.grab_focus()#habilita o teclado para selcionar a opção

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true

func _on_resume_btn_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
