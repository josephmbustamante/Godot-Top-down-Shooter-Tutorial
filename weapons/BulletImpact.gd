extends Particles2D


onready var timer = $Timer


func start_emitting():
	timer.wait_time = lifetime + 0.1
	timer.start()
	emitting = true


func _on_Timer_timeout() -> void:
	queue_free()
