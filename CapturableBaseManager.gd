extends Node2D


signal player_captured_all_bases
signal player_lost_all_bases


var capturable_bases: Array = []


func _ready() -> void:
	capturable_bases = get_children()
	for base in capturable_bases:
		base.connect("base_captured", self, "handle_base_captured")


func get_capturable_bases() -> Array:
	return capturable_bases


func handle_base_captured(_team):
	var player_bases = 0
	var enemy_bases = 0
	var total_bases = capturable_bases.size()

	for base in capturable_bases:
		match base.team.team:
			Team.TeamName.PLAYER:
				player_bases += 1
			Team.TeamName.ENEMY:
				enemy_bases += 1
			Team.TeamName.NEUTRAL:
				return

	if player_bases == total_bases:
		emit_signal("player_captured_all_bases")
	elif enemy_bases == total_bases:
		emit_signal("player_lost_all_bases")
