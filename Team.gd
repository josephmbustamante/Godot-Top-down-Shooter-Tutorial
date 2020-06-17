extends Node2D
class_name Team


enum TeamName {
	NEUTRAL,
	PLAYER,
	ENEMY
}


export (TeamName) var team = TeamName.NEUTRAL
