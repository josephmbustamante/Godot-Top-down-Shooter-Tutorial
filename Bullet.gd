extends Area2D


export (int) var speed = 10


var direction := Vector2.ZERO


func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction * speed

		global_position += velocity


func set_direction(direction: Vector2):
	self.direction = direction
