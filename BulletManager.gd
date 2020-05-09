extends Node2D


func handle_bullet_spawned(bullet, position, direction):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_direction(direction)
