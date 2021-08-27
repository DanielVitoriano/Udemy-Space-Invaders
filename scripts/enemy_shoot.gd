extends Area2D

const vel = 120
const dir = Vector2(0, 1)

func _ready():
	add_to_group("enemy_shoot")
	$anim.play("enemy_shoot")

func _process(delta):
	translate(dir * vel * delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func destroy():
	queue_free()


func _on_enemy_shoot_area_entered(area):
	if area.has_method("destroy"):
		area.destroy()
		destroy()
	
	elif area.has_method("damage"):
		area.damage()
		destroy()
