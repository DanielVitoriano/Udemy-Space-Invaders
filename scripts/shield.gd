extends Area2D

var life = 0

func _ready():
	pass

func damage():
	life += 1
	
	if life <= 5:
		$Sprite.frame = life
	
	else:
		queue_free()
