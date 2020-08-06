extends Node2D
class_name AI


signal state_changed(new_state)


enum State {
	PATROL,
	ENGAGE,
	ADVANCE
}


onready var patrol_timer = $PatrolTimer


var current_state: int = -1 setget set_state
var actor: Actor = null
var target: KinematicBody2D = null
var weapon: Weapon = null
var team: int = -1

# PATROL STATE
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var actor_velocity: Vector2 = Vector2.ZERO

# ADVANCE STATE
var next_base: Vector2 = Vector2.ZERO

var pathfinding: Pathfinding


func _ready() -> void:
	set_state(State.PATROL)


func _physics_process(delta: float) -> void:
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				var path = pathfinding.get_new_path(global_position, patrol_location)
				if path.size() > 1:
					actor_velocity = actor.velocity_toward(path[1])
					actor.rotate_toward(path[1])
					actor.move_and_slide(actor_velocity)
				else:
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if target != null and weapon != null:
				actor.rotate_toward(target.global_position)
				var angle_to_target = actor.global_position.direction_to(target.global_position).angle()
				if abs(actor.rotation - angle_to_target) < 0.1:
					weapon.shoot()
			else:
				print("In the engage state but no weapon/target")
		State.ADVANCE:
			var path = pathfinding.get_new_path(global_position, next_base)
			if path.size() > 1:
				actor_velocity = actor.velocity_toward(path[1])
				actor.rotate_toward(path[1])
				actor.move_and_slide(actor_velocity)
			else:
				set_state(State.PATROL)
		_:
			print("Error: found a state for our enemy that should not exist")


func initialize(actor: KinematicBody2D, weapon: Weapon, team: int):
	self.actor = actor
	self.weapon = weapon
	self.team = team

	weapon.connect("weapon_out_of_ammo", self, "handle_reload")


func set_state(new_state: int):
	if new_state == current_state:
		return

	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true

	elif new_state == State.ADVANCE:
		if actor.has_reached_position(next_base):
			set_state(State.PATROL)

	current_state = new_state
	emit_signal("state_changed", current_state)


func handle_reload():
	weapon.start_reload()


func _on_PatrolTimer_timeout() -> void:
	var patrol_range = 150
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false


func _on_DetectionZone_body_entered(body: Node) -> void:
	if body.has_method("get_team") and body.get_team() != team:
		set_state(State.ENGAGE)
		target = body


func _on_DetectionZone_body_exited(body: Node) -> void:
	if target and body == target:
		set_state(State.ADVANCE)
		target = null
