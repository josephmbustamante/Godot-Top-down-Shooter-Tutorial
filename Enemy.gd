extends KinematicBody2D


var health: int = 100


func handle_hit():
	health -= 20
	if health <= 0:
		queue_free()
