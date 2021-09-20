extends KinematicBody2D
class_name Actor


signal died


onready var collision_shape = $CollisionShape2D
onready var health_stat = $Health
onready var ai = $AI
onready var weapon: Weapon = $Weapon
onready var team = $Team


export (int) var speed = 150


func _ready() -> void:
	ai.initialize(self, weapon, team.team)
	weapon.initialize(team.team)


func rotate_toward(location: Vector2):
	rotation = lerp_angle(rotation, global_position.direction_to(location).angle(), 0.1)


func velocity_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed


func has_reached_position(location: Vector2) -> bool:
	return global_position.distance_to(location) < 5


func get_team() -> int:
	return team.team


func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		die()


func die():
	emit_signal("died")
	queue_free()
