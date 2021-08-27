extends Area2D

const VELOCITY = 100

var PRE_SHOOT = preload("res://scenes/prefab/player_shoot.tscn")
var lazer_charge = 1
var alive = true

signal shoot_sfx
signal destroy_sfx
signal ship_destroyed
signal respaw

func _ready():
	hide()
	set_process(false)
	pass

func _process(delta):
	move(delta)
	limited()
	
	if Input.is_action_pressed("ui_shoot") and lazer_charge >= 1:
		shoot()

func limited():
#	if global_position.x < 7:
#		global_position.x = 7
#
#	if global_position.x > 173:
#		global_position.x = 173
	
	global_position = Vector2(clamp(global_position.x, 7, ProjectSettings.get("display/window/size/width") - 7), global_position.y)

func shoot():
	lazer_charge -= 1
	$shoot_time.start()
	
	var shoot = PRE_SHOOT.instance()
	shoot.global_position = $pos_shoot.global_position
	get_parent().add_child(shoot)
	emit_signal("shoot_sfx")
	
	yield($shoot_time,"timeout")
	lazer_charge = 1
	

func move(delt):
	var dir = 0
	
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	
	if right:
		dir += 1
		
	elif left:
		dir -= 1
		
	translate(Vector2(1, 0) * VELOCITY * dir * delt)

func destroy():
	if alive:
		alive = false
		set_process(false)
		emit_signal("destroy_sfx")
		emit_signal("ship_destroyed")
		$anim.play("destroy")
		yield($anim,"animation_finished")
		emit_signal("respaw")
		set_process(true)
		alive = true
		$Sprite.frame = 0

func start():
	show()
	set_process(true)

func disable():
	hide()
	set_process(false)
	alive = false
