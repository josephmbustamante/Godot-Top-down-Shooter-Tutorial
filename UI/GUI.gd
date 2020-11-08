extends CanvasLayer


onready var health_bar = $MarginContainer/Rows/BottomRow/HealthSection/HealthBar
onready var health_tween = $MarginContainer/Rows/BottomRow/HealthSection/HealthTween
onready var current_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/CurrentAmmo
onready var max_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/MaxAmmo


var player: Player


func set_player(player: Player):
	self.player = player

	set_new_health_value(player.health_stat.health)
	player.connect("player_health_changed", self, "set_new_health_value")

	set_weapon(player.weapon_manager.get_current_weapon())
	player.weapon_manager.connect("weapon_changed", self, "set_weapon")


func set_weapon(weapon: Weapon):
	set_current_ammo(weapon.current_ammo)
	set_max_ammo(weapon.max_ammo)
	if not weapon.is_connected("weapon_ammo_changed", self, "set_current_ammo"):
		weapon.connect("weapon_ammo_changed", self, "set_current_ammo")


func set_new_health_value(new_health: int):
	var original_color = Color("#5c1c1c")
	var highlight_color = Color("#ff7e7e")

	var bar_style = health_bar.get("custom_styles/fg")
	health_tween.interpolate_property(health_bar, "value", health_bar.value, new_health, 0.4,Tween.TRANS_LINEAR, Tween.EASE_IN)
	health_tween.interpolate_property(bar_style, "bg_color", original_color, highlight_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	health_tween.interpolate_property(bar_style, "bg_color", highlight_color, original_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	health_tween.start()


func set_current_ammo(new_ammo: int):
	current_ammo.text = str(new_ammo)


func set_max_ammo(new_max_ammo: int):
	max_ammo.text = str(new_max_ammo)
