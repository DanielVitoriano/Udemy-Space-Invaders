extends Node

const extra_life_points = [1000, 2500, 5000]

var data = {
	 extra_life_index = 0,
	 score = 0,
	 lifes = 3
} setget set_data


signal game_over
signal victory

func _ready():
	randomize()
	$spaceShip.connect("ship_destroyed", self, "on_player_destroyed")
	$spaceShip.connect("respaw", self, "on_respaw")
	$alien_group.connect("increase_score", self, "on_alien_enemy_dead")
	$alien_group.connect("ready_go", self, "on_ready_go")
	$alien_group.connect("earth_dominated", self, "on_earth_dominated")
	$alien_group.connect("victory", self, "on_victory")
	increase_score()

func on_alien_enemy_dead(alien):
	data.score += alien.score
	if  data.extra_life_index < extra_life_points.size() and data.score >= extra_life_points[data.extra_life_index]:
		data.lifes += 1
		lifes_update()
		data.extra_life_index += 1
	increase_score()

func update_HUD():
	lifes_update()
	increase_score()

func increase_score():
	$HUD/score.text = str(data.score)

func on_player_destroyed():
	$alien_group.stop()
	data.lifes -= 1
	lifes_update()
	get_tree().call_group("enemy_shoot", "destroy")

func on_respaw():
	$alien_group.start()
	if data.lifes <= 0:
		game_over()

func on_ready_go():
	$spaceShip.start()

func on_earth_dominated():
	game_over()

func game_over():
	$alien_group.stop()
	$spaceShip.disable()
	$spaceShip.queue_free()
	emit_signal("game_over")

func on_victory():
	$alien_group.stop()
	$spaceShip.disable()
	emit_signal("victory")

func lifes_update():
	$HUD/life_draw.set_lifes(data.lifes)

func set_data(val):
	data = val
	update_HUD()
