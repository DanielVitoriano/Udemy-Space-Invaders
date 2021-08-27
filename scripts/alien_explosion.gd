extends Node2D


func _ready():
	$anim.play("explosion")
	yield($anim, "animation_finished")
	queue_free()
