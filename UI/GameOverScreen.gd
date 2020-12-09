extends CanvasLayer


onready var title = $PanelContainer/MarginContainer/Rows/Title
onready var animation_player = $AnimationPlayer


func _ready() -> void:
	animation_player.play("fade")


func set_title(win: bool):
	if win:
		title.text = "YOU WIN!"
		title.modulate = Color.green
	else:
		title.text = "YOU LOSE!"
		title.modulate = Color.red


func _on_RestartButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://Main.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_MainMenuButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://UI/MainMenuScreen.tscn")
