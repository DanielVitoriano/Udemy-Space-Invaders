extends Node2D

var PRE_SHOOT = preload("res://scenes/prefab/enemy_shoot.tscn")
var PRE_EXPLOSION = preload("res://scenes/prefab/alien_explosion.tscn")
var PRE_MOTHER_SHIP = preload("res://scenes/prefab/mother_ship.tscn")

var game_over = false
var dir = 1
var vel = Vector2(6, 0)
var note = 0
var samples = [load("res://Assets/samples/nota1.wav"), 
load("res://Assets/samples/nota2.wav"), load("res://Assets/samples/nota3.wav"), load("res://Assets/samples/nota4.wav")]

signal increase_score(obj)
signal ready_go
signal earth_dominated
signal victory

func _ready():
	
	start_timer_mother_ship()
	
	for alien in get_node("aliens").get_children():
		alien.hide()
		alien.connect("emit_dead", self, "on_alien_destroy")
	
	for alien in get_node("aliens").get_children():
		$Timer_show.start()
		yield($Timer_show, "timeout")
		alien.show()
	
	emit_signal("ready_go")
	start()
	
func shoot():
	$sfx_shoot.play()
	var n_aliens = get_node("aliens").get_child_count()
	if n_aliens > 0:
		var shoot = PRE_SHOOT.instance()
		var alien = get_node("aliens").get_child(randi() % n_aliens)
		get_parent().add_child(shoot)
		shoot.global_position = alien.global_position


func _on_Timer_timeout():
	$Timer.wait_time = rand_range(0.5, 3)
	shoot()

func _on_Timer_move_timeout():
	
	$samples.stream = samples[note]
	$samples.play()
	note += 1
	if note > 3:
		note = 0
	
	var border = false
	
	for alien in get_node("aliens").get_children():
		alien.next_frame()
		if alien.global_position.x >= 170 and dir > 0:
			dir = -1 
			border = true
			
		if alien.global_position.x <= 10 and dir < 0:
			dir = 1
			border = true
		
		if alien.global_position.y > 267 and !game_over:
			emit_signal("earth_dominated")
			game_over = true
			
	if border:
		translate(Vector2(0, 8))
		border = false
		
		if $Timer_move.wait_time > .11:
			$Timer_move.wait_time -= .08
	
	else:
		translate(vel * dir)

func on_alien_destroy(alien):
	$sfx_explosion.play()
	emit_signal("increase_score", alien)
	
	var alien_explosion = PRE_EXPLOSION.instance()
	get_parent().add_child(alien_explosion)
	alien_explosion.global_position = alien.global_position
	
	if get_node("aliens").get_child_count() == 1:
		stop()
		emit_signal("victory")


func _on_Timer_mother_ship_timeout():
	var mother_ship = PRE_MOTHER_SHIP.instance()
	mother_ship.connect("emit_dead", self, "on_alien_destroy")
	get_parent().add_child(mother_ship)
	start_timer_mother_ship()

func start_timer_mother_ship():
	$Timer_mother_ship.start()
	$Timer_mother_ship.wait_time = rand_range(4, 15)

func stop():
	$Timer.stop()
	$Timer_move.stop()
	$Timer_mother_ship.stop()

func start():
	$Timer.start()
	$Timer_move.start()
	$Timer_mother_ship.start()
	game_over = false
