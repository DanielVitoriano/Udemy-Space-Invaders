extends Area2D

var damage_hit = 10
var velocity = 150
var dir = Vector2(0, -1)

func _ready():
	pass

func _process(delta):
	move(delta)

func move(delta):
	translate(dir * velocity * delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_player_shoot_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
		destroy()
	elif area.has_method("damage"):
		area.damage()
		destroy()

func destroy():
	queue_free()
