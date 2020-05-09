extends KinematicBody2D


signal player_fired_bullet(bullet, position, direction)


export (PackedScene) var Bullet
export (int) var speed = 100


onready var end_of_gun = $EndOfGun


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var movement_direction := Vector2.ZERO

	if Input.is_action_pressed("up"):
		movement_direction.y = -1
	if Input.is_action_pressed("down"):
		movement_direction.y = 1
	if Input.is_action_pressed("left"):
		movement_direction.x = -1
	if Input.is_action_pressed("right"):
		movement_direction.x = 1

	movement_direction = movement_direction.normalized()
	move_and_slide(movement_direction * speed)

	look_at(get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		shoot()


func shoot():
	var bullet_instance = Bullet.instance()
	var target = get_global_mouse_position()
	var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
	emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction_to_mouse)
