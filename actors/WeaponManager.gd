extends Node2D


signal weapon_changed(new_weapon)


onready var current_weapon: Weapon = $Pistol


var weapons: Array = []


func _ready() -> void:
	weapons = get_children()

	for weapon in weapons:
		weapon.hide()

	current_weapon.show()


func _process(delta: float) -> void:
	if not current_weapon.semi_auto and Input.is_action_pressed("shoot"):
		current_weapon.shoot()


func initialize(team: int) -> void:
	for weapon in weapons:
		weapon.initialize(team)


func get_current_weapon() -> Weapon:
	return current_weapon


func reload():
	current_weapon.start_reload()


func switch_weapon(weapon: Weapon):
	if weapon == current_weapon:
		return

	current_weapon.hide()
	weapon.show()
	current_weapon = weapon
	emit_signal("weapon_changed", current_weapon)


func _unhandled_input(event: InputEvent) -> void:
	if current_weapon.semi_auto and event.is_action_released("shoot"):
		current_weapon.shoot()
	elif event.is_action_released("reload"):
		current_weapon.start_reload()
	elif event.is_action_released("weapon_1"):
		switch_weapon(weapons[0])
	elif event.is_action_released("weapon_2"):
		switch_weapon(weapons[1])
